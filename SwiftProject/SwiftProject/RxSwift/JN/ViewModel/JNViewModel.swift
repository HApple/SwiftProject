//
//  JNViewModel.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/9.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

extension Reactive where Base: UIScrollView {
    
    var refreshStatus: Binder<JNRefreshStatus> {
        return Binder(base) { scrollView, status in
            switch status {
            case .beingHeaderRefresh:
                base.mj_header?.beginRefreshing()
                base.mj_footer?.resetNoMoreData()
            case .endHeaderRefresh:
                base.mj_header?.endRefreshing()
            case .beginFooterRefresh:
                base.mj_footer?.beginRefreshing()
            case .endFooterRefresh:
                base.mj_footer?.endRefreshing()
            case .noMoreData:
                base.mj_footer?.endRefreshingWithNoMoreData()
            case .none:
                base.mj_header?.endRefreshing()
                base.mj_footer?.endRefreshing()
            }
        }
    }
    
}


enum JNRefreshStatus {
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beginFooterRefresh
    case endFooterRefresh
    case noMoreData
}

class JNViewModel: NSObject {
    let models = BehaviorRelay<[JNModel]>(value: [])
    var index: Int = 1
}

extension JNViewModel: JNViewModelType {
    
    typealias Input = JNInput
    typealias Output = JNOutput
    
    struct JNInput {
        let category: JNAPI.JNAPICategory
        
        init(category: JNAPI.JNAPICategory) {
            self.category = category
        }
    }
    
    struct JNOutput {
        // tableView的sections数据
        let sections: Driver<[JNSection]>
        // 外界通过该属性告诉viewModel加载数据（传入的值是为了标志是否重新加载）
        let requestCommand = PublishSubject<Bool>()
        // 告诉外界的tableView当前的刷新状态
        let refreshStatus = BehaviorRelay<JNRefreshStatus>(value: .none)
        
        init(sections: Driver<[JNSection]>) {
            self.sections = sections
        }
        
    }
    
    func transfrom(input: JNInput) -> JNOutput {
        let sections = models.asObservable().map { models -> [JNSection] in
            // 当models的值被改变时会调用
            return [JNSection(items: models)]
        }.asDriver(onErrorJustReturn: [])
        
        let output = JNOutput(sections: sections)
        
        output.requestCommand.subscribe(onNext: { [unowned self] isReloadData in
            self.index = isReloadData ? 1 : self.index + 1
            JNAPIProvider.rx.request(.data(type: input.category, size: 10, index: self.index))
                .asObservable()
                .mapArray(JNModel.self, designatedPath: "results")
                .subscribe { [weak self] event in
                    switch event {
                    case .next(let modelArr):
                        if isReloadData {
                            self?.models.accept(modelArr)
                        }else {
                            let array = (self?.models.value ?? [] ) + modelArr
                            self?.models.accept(array)
                        }
                    case .error(let error):
                        output.refreshStatus.accept(.none)
                        JNProgressHUD.showError(error.localizedDescription)
                    case .completed:
                        output.refreshStatus.accept(isReloadData ? .endHeaderRefresh : .endFooterRefresh)
                    }
                }.disposed(by: rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return output
    }
}

