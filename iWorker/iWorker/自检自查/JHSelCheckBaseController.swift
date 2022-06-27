//
//  JHSelCheckBaseController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase

class JHSelCheckBaseController: JHBaseNavVC {

    var storeId = "00000000-0000-0000-0000-000000000000"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createView()
    }
    
    func createView() {
        navTitle = "自检自查"
        navBar.backgroundColor = .clear
        navBar.titleLabel.textColor = .white
        navBar.lineView.isHidden = true
        navBar.backBtn.setImage(.init(named: "Inspect返回"), for: .normal)
        
        
        view.addSubviews([stepView,tableView])
        view.sendSubviewToBack(stepView)
        stepView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            let height = kPhoneXSeries ? 150:130
            make.height.equalTo(height)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom)
            make.right.left.bottom.equalToSuperview()
        }
    }
    
    // 导航条背景图
    lazy var stepView: UIImageView = {
        let header = UIImageView()
        let image = UIImage(named: "stepfirst")
//        image?.resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
        header.image = image
        return header
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .white
        tb.removeTableFooterView()
        tb.separatorStyle = .singleLine
        tb.estimatedRowHeight = 75
        tb.separatorColor = .k666666
        tb.rowHeight = UITableView.automaticDimension
        return tb
    }()
}


