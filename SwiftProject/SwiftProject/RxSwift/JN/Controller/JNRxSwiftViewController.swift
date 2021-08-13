//
//  JNRxSwiftViewController.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/10.
//

import UIKit
import Reusable
import Then
import RxDataSources
import MJRefresh

class JNRxSwiftViewController: UIViewController {

    let viewModel = JNViewModel()
    let tableView = UITableView().then {
        $0.register(cellType: JNViewCell.self)
        $0.rowHeight = 240
    }
    let dataSource = RxTableViewSectionedReloadDataSource<JNSection> { dataSource, tbView, indexPath, item in
        let cell = tbView.dequeueReusableCell(for: indexPath) as JNViewCell
        cell.picView.kf.setImage(with: URL(string: item.url))
        cell.descLabel.text = "描述: \(item.desc)"
        cell.sourceLabel.text = "来源: \(item.source)"
        return cell
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        tableView.mj_header?.beginRefreshing()
    }
}

extension JNRxSwiftViewController {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func bindViewModel() {
        
        //设置代理
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        let vmInput = JNViewModel.JNInput(category: .welfare)
        let vmOutput = viewModel.transfrom(input: vmInput)
        
        vmOutput.sections.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        
        vmOutput.refreshStatus.bind(to: tableView.rx.refreshStatus).disposed(by: rx.disposeBag)
        
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            vmOutput.requestCommand.onNext(true)
        })
        
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            vmOutput.requestCommand.onNext(false)
        })
    }
}

extension JNRxSwiftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
