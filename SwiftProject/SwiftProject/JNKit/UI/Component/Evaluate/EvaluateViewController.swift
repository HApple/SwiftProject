//
//  EvaluateViewController.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/4.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class EvaluateViewController: UIViewController {
    
    var datas:[EvaluateModel] = [EvaluateModel]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UINib(nibName: "EvaluateCell", bundle: nil), forCellReuseIdentifier: "EvaluateCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func setupData() {
        var content:String = "我的发撒放松放松发货啦是数据"
        var imgURLs:[String] = [String]()
        for i in 0..<10 {
            
            var model = EvaluateModel()
            model.avatarURL = "http://fdfs.xmcdn.com/group37/M07/A2/58/wKgJoFpNnQHRXc7aAAANp1i8KKY422_mobile_small.jpg"
            model.content = content
            model.name = "sgasgsgs \(i)"
            model.imgURLs = imgURLs
           // model.rowHeight = EvaluateCell.cellHeight(with: model)
            datas.append(model)
            
            imgURLs.append("https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fp2.itc.cn%2Fimages03%2F20200517%2F463027a65c68465ab92eac7a84bf7c7c.jpeg&refer=http%3A%2F%2Fp2.itc.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1630655368&t=71dda6b629f85121988cb5643c9e5a1c")
            if i < 4 {
                content += content
            }
        }
        tableView.reloadData()
    }
}

extension EvaluateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return datas[indexPath.row].rowHeight ?? 0
//        let item = datas[indexPath.row]
//        return tableView.fd_heightForCell(withIdentifier: "EvaluateCell", cacheBy: indexPath) { cell in
//            if let cell = cell as? EvaluateCell {
//                cell.configure(with: item)
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EvaluateCell = tableView.dequeueReusableCell(withIdentifier: "EvaluateCell", for: indexPath) as! EvaluateCell
        cell.configure(with: datas[indexPath.row])
        return cell
    }
    
}
