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
        loadData()
    }
    
    func loadData() {}
    
    @objc
    func nextStepAction() {
        //TODO: 下一步
        print("下一步....")
    }
    
    func createView() {
        navTitle = "自检自查"
        navBar.backgroundColor = .clear
        navBar.titleLabel.textColor = .white
        navBar.lineView.isHidden = true
        navBar.backBtn.setImage(.init(named: "Inspect返回"), for: .normal)
        view.addWaterText(text: "测试文本", color: .darkGray, font: .systemFont(ofSize: 15))
        
        view.addSubviews([stepView,tableView])

        let index = view.subviews.firstIndex(of: navBar) ?? 0
        view.insertSubview(stepView, at: index)
        stepView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            let height = kPhoneXSeries ? 150:130
            make.height.equalTo(height)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom)
            make.right.left.bottom.equalToSuperview()
        }
        
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        footerView.frame.size.height = height
        tableView.tableFooterView = footerView
    }
    
    // 导航条背景图
    lazy var stepView: UIImageView = {
        let header = UIImageView()
        header.contentMode = .scaleToFill
        return header
    }()
    
    func setStepImage(img:String) {
        let image = UIImage(named: img)
        //resizableImageWithCapInsets: 指定拉伸区域
        let rect = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        stepView.image = image?.resizableImage(withCapInsets: rect, resizingMode: .stretch) //拉伸
    }
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .clear
        tb.removeTableFooterView()
        tb.separatorStyle = .singleLine
        tb.estimatedRowHeight = 75
        tb.separatorColor = .k666666
        tb.separatorInset = .zero
        tb.rowHeight = UITableView.automaticDimension
        return tb
    }()
    
    lazy var footerView: UIView = {
        let footer = UIView()
        footer.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.height.equalTo(50)
            make.top.equalTo(40)
            make.center.equalToSuperview()
        }
        return footer
    }()
    
    lazy var bottomBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("下一步", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .initWithHex("FDAD44")
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(nextStepAction), for: .touchDown)
        return btn
    }()
}


