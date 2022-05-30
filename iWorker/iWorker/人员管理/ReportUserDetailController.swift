//
//  ReportUserDetailController.swift
//  iWorker
//
//  Created by boyer on 2022/5/23.
//

import JHBase
import UIKit

class ReportUserDetailController: JHBaseNavVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "人员信息"
        
        createView()
    }
    
    func createView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.estimatedRowHeight = 150
        tb.rowHeight = UITableView.automaticDimension
        tb.removeTableFooterView()
        let v = headerView
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        v.frame.size.height = height
        tb.tableHeaderView = v
        return tb
    }()
    
    lazy var headerView: UIView = {
        let header = UIView()
        header.addSubviews([userInfoView,switchView,statusView])
        
        userInfoView.snp.makeConstraints { make in
            make.centerX.left.top.equalToSuperview()
        }
        switchView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom)
            make.centerX.left.equalToSuperview()
        }
        statusView.snp.makeConstraints { make in
            make.top.equalTo(switchView.snp.bottom)
            make.left.centerX.bottom.equalToSuperview()
        }
        
        return header
    }()
    
    let icon = UIImageView()
    let name = UILabel()
    let idLab = UILabel()
    let addr = UILabel()
    let tel = UILabel()
    
    lazy var userInfoView: UIView = {
        let info = UIView()
        
        icon.image = .init(named: "vatoricon")
        
        name.textColor = .k2F3856
        name.font = .systemFont(ofSize: 15)
        
        idLab.textColor = .k99A0B6
        idLab.font = .systemFont(ofSize: 12)
        
        let btn = UIButton()
        btn.setTitle("足迹", for: .normal)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.k428BFE.cgColor
        
        name.text = "test"
        idLab.text = "test"
        addr.text = "test"
        tel.text = "test"
        
        let line = UIView()
        line.backgroundColor = .kF6F6F6
        
        info.addSubviews([icon,name,idLab,addr,tel,btn,line])
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.top.equalTo(10)
            make.left.equalTo(12)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.top)
            make.left.equalTo(icon.snp.right).offset(8)
        }
        idLab.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(8)
            make.bottom.equalTo(icon.snp.bottom)
        }
        addr.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.equalTo(8)
        }
        tel.snp.makeConstraints { make in
            make.top.equalTo(addr.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.equalTo(8)
        }
        btn.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalTo(icon.snp.centerY)
            make.size.equalTo(CGSize(width: 44, height: 24))
        }
        line.snp.makeConstraints { make in
            make.top.equalTo(tel.snp.bottom).offset(10)
            make.height.equalTo(10)
            make.bottom.left.right.equalToSuperview()
        }
        return info
    }()
    
    lazy var groupView: ReportGroupView = {
        let groupView = ReportGroupView()
        let group1 = ReportGroupModel(Id: "0", name: "上报任务", selected: true)
        let group2 = ReportGroupModel(Id: "1", name: "巡查任务", selected: false)
        groupView.dataArray = [group1,group2]
        groupView.handlerBlock = {[weak self] model in
            guard let wf = self else{return}
            wf.switchGroup(model)
        }
        return groupView
    }()
    
    lazy var switchView: UIView = {
        let switchView = UIView()
        
        let switchBtn = UIButton()
        switchBtn.setTitle("上报任务", for: .normal)
        switchBtn.setTitleColor(.k2F3856, for: .normal)
        switchBtn.setImage(.init(named: "arrowdown"), for: .normal)
        
        let line = UIView()
        line.backgroundColor = .kF6F6F6
        
        switchView.addSubviews([line, switchBtn])
        switchBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(switchBtn.snp.bottom).offset(10)
            make.bottom.left.centerX.equalToSuperview()
        }
        return switchView
    }()
    
    lazy var statusView: UIView = {
        let status = UIView()
        // 创建segmentedControl
        let items = ["待检查", "超期未查", "已完成"]
        let segmentedControl = JHSegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChange(_ :)), for: .valueChanged)
        
        let line = UIView()
        line.backgroundColor = .kF6F6F6
        
        status.addSubviews([segmentedControl,line])
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.height.equalTo(30)
            make.left.equalToSuperview()
        }
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.bottom.left.centerX.equalToSuperview()
        }
        return status
    }()
    func segmentedControlChange(_ segmented: JHSegmentedControl) {
        segmented.animateLine()
        if segmented.selectedSegmentIndex == 0 {
        }
        else if segmented.selectedSegmentIndex == 1 {
            print("第1个啊哈哈")
        }
        else {
            print("其他啊哈哈")
        }
    }
}



extension ReportUserDetailController:UITableViewDelegate,UITableViewDataSource
{
    func switchGroup(_ group:ReportGroupModel) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

