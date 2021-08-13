//
//  DouBanViewController.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/9.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class DouBanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DouBanProvider.rx.request(.channels)
            .subscribe { event in
                switch event {
                case let .success(response):
                    let str = String(data: response.data, encoding: .utf8)
                    print(str ?? "")
                case let .error(error):
                    print(error)
                }
            }.disposed(by: rx.disposeBag)
    }
}
