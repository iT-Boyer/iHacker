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
        
    }
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.estimatedRowHeight = 150
        tb.rowHeight = UITableView.automaticDimension
        tb.removeTableFooterView()
        return tb
    }()
    
    lazy var headerView: UIView = {
        let header = UIView()
        let line = UIView()
        line.backgroundColor = .kF6F6F6
        header.addSubviews([userInfoView,groupView,switchView])
        
        
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
        info.addSubviews([icon,name,idLab,addr,tel])
        
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
            make.bottom.equalTo(-10)
        }
        btn.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalTo(icon.snp.centerY)
            make.size.equalTo(CGSize(width: 44, height: 24))
        }
        return info
    }()
    
    lazy var groupView: UIView = {
        let group = UIView()
        
        return group
    }()
    
    lazy var switchView: UIView = {
        let switchBtn = UIButton()
        switchBtn.setTitle("上报任务", for: .normal)
        switchBtn.setTitleColor(.k2F3856, for: .normal)
        switchBtn.setImage(.init(named: "arrowdown"), for: .normal)
        
        return switchBtn
    }()
}

extension ReportUserDetailController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

