//
//  ReportUserDetailController.swift
//  iWorker
//
//  Created by boyer on 2022/5/23.
//

import JHBase
import UIKit
import MBProgressHUD
import SwiftyJSON

class ReportUserDetailController: JHBaseNavVC {
    
    var userId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "人员信息"
        
        createView()
        
        loadUserData()
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
        name.text = " "
        name.font = .systemFont(ofSize: 15)
        
        idLab.textColor = .k99A0B6
        idLab.text = " "
        idLab.font = .systemFont(ofSize: 12)
        
        addr.text = "所属区域："
        addr.textColor = .k99A0B6
        addr.font = .systemFont(ofSize: 13)
        
        tel.text = "联系电话："
        tel.textColor = .k99A0B6
        tel.font = .systemFont(ofSize: 13)
        
        let btn = UIButton()
        btn.setTitle("足迹", for: .normal)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.k428BFE.cgColor
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.setTitleColor(.k428BFE, for: .normal)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            let trackVC = ReportTrackPachController()
            wf.navigationController?.pushViewController(trackVC)
        }
        
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
        groupView.isHidden = true
        let group1 = ReportGroupModel(Id: "0", name: "上报任务", selected: true)
        let group2 = ReportGroupModel(Id: "1", name: "巡查任务", selected: false)
        groupView.dataArray = [group1,group2]
        groupView.handlerBlock = {[weak self] model in
            guard let wf = self else{return}
            wf.groupView.isHidden = true
            wf.switchGroup(model)
        }
        return groupView
    }()
    
    lazy var switchView: UIView = {
        let switchView = UIView()
        
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
    lazy var switchBtn: UIButton = {
        let switchBtn = UIButton()
        switchBtn.setTitle("上报任务", for: .normal)
        switchBtn.setTitleColor(.k2F3856, for: .normal)
        switchBtn.titleLabel?.font = .systemFont(ofSize: 13)
        switchBtn.setImage(.init(named: "arrowdown"), for: .normal)
        //图片在右，文字在左
        switchBtn.semanticContentAttribute = .forceRightToLeft
        switchBtn.jh.setHandleClick {[weak self] button in
            guard let wf = self else{return}
            wf.view.addSubview(wf.groupView)
            wf.groupView.isHidden = !wf.groupView.isHidden
            wf.groupView.snp.makeConstraints { make in
                make.top.equalTo(wf.headerView.snp.bottom).offset(-48)
                make.left.bottom.centerX.equalToSuperview()
            }
        }
        return switchBtn
    }()
    lazy var statusView: UIView = {
        let status = UIView()
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
        switchBtn.setTitle(group.name, for: .normal)
        
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

extension ReportUserDetailController
{
    func loadUserData() {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "LoginUserId":JHBaseInfo.userID,
                                  "ChooseUserId":userId]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/Employee/v3/GetEmployeeInfo")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
                //                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsCompleted"].boolValue
            if result {
                let rawData = try! json["Data"].rawData()
                let info:ReportUserInfoM = ReportUserInfoM.parsed(data: rawData)
                weakSelf.name.text = info.employeeName
                weakSelf.idLab.text = "ID："+info.employeeID
                let textattr:[NSAttributedString.Key:Any] = [
                    .foregroundColor:UIColor.k99A0B6,
                    .font:UIFont.systemFont(ofSize: 13)
                ]
                let textendattr:[NSAttributedString.Key:Any] = [
                    .foregroundColor:UIColor.k2F3856,
                    .font:UIFont.systemFont(ofSize: 13)
                ]
                let addr = info.areaNames.first ?? ""
                let addrtext = NSAttributedString(string: "所属区域：\(addr)",attributes: textattr)
                weakSelf.addr.attributedText = addrtext.applying(attributes: textendattr, toRangesMatching: addr)
                let teltext = NSAttributedString(string: "联系电话：\(info.employeeMobile)",attributes: textattr)
                weakSelf.tel.attributedText = teltext.applying(attributes: textendattr, toRangesMatching: info.employeeMobile)
                weakSelf.icon.kf.setImage(with: URL(string: info.employeeHeadIcon), placeholder: UIImage(named: "vatoricon"))
            }else{
                let msg = json["exceptionMsg"].stringValue
                //                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
}
