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
    var groupId = "0"
    var pageIndex = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "人员信息"
        
        createView()
        loadUserData()
        
        loadFlagData()
//        loadTaskData(status: 2)
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
        tb.register(ReportPatrolInfoCell.self, forCellReuseIdentifier: "ReportPatrolInfoCell")
        tb.register(ReportTaskInfoCell.self, forCellReuseIdentifier: "ReportTaskInfoCell")
        tb.es.addPullToRefresh { [weak self] in
            guard let wf = self else{return}
            /// 在这里做刷新相关事件
            wf.pageIndex = 1
            if wf.groupId == "0" {
                wf.loadTaskData(status: 2)
            }
            if wf.groupId == "1" {
                wf.loadPatrolData(taskStatus: 0)
            }
//            /// 如果你的刷新事件成功，设置completion自动重置footer的状态
//            self.tableView.es.stopPullToRefresh()
//            /// 设置ignoreFooter来处理不需要显示footer的情况
//            self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
        }
        
        /// 在这里做加载更多相关事件
        tb.es.addInfiniteScrolling { [weak self] in
            guard let wf = self else{return}
            if wf.groupId == "0" {
                wf.loadTaskData(status: 2)
            }
            if wf.groupId == "1" {
                wf.loadPatrolData(taskStatus: 0)
            }
//            /// 如果你的加载更多事件成功，调用es_stopLoadingMore()重置footer状态
//            self.tableView.es.stopLoadingMore()
//            /// 通过es_noticeNoMoreData()设置footer暂无数据状态
//            self.tableView.es.noticeNoMoreData()
        }
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
    
    lazy var userInfoView: UIView = {
        let info = UIView()
        
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
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = .init(named: "vatoricon")
        icon.layer.cornerRadius = 18
        icon.masksToBounds = true
        return icon
    }()
    
    lazy var name: UILabel = {
        let lab = UILabel()
        lab.textColor = .k2F3856
        lab.text = " "
        lab.font = .systemFont(ofSize: 15)
        return lab
    }()

    lazy var idLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .k99A0B6
        lab.text = " "
        lab.font = .systemFont(ofSize: 12)
        return lab
    }()
    lazy var addr: UILabel = {
        let lab = UILabel()
        lab.text = "所属区域："
        lab.textColor = .k99A0B6
        lab.font = .systemFont(ofSize: 13)
        return lab
    }()
    lazy var tel: UILabel = {
        let lab = UILabel()
        lab.text = "联系电话："
        lab.textColor = .k99A0B6
        lab.font = .systemFont(ofSize: 13)
        return lab
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
            wf.tableView.isScrollEnabled = false
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
    
    lazy var segmentedControl: JHSegmentedControl = {
        let items = ["待检查", "超期未查", "已完成"]
        let segmentedControl = JHSegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChange(_ :)), for: .valueChanged)
        return segmentedControl
    }()
    
    func segmentedControlChange(_ segmented: JHSegmentedControl) {
        segmented.animateLine()
        var status = 2
        if segmented.selectedSegmentIndex == 0 {
            status = 2
        }
        else if segmented.selectedSegmentIndex == 1 {
            status = 3
        }
        else {
            status = 4
        }
        pageIndex = 1
        if groupId == "0" {
            loadTaskData(status: status)
        }
        if groupId == "1" {
            loadPatrolData(taskStatus: segmented.selectedSegmentIndex)
        }
        
    }
    
    lazy var dataArray: [ReportTaskModel] = {
        
        return []
    }()
    lazy var patrolArray: [PatrolTaskModel] = {
        
        return []
    }()
}



extension ReportUserDetailController:UITableViewDelegate,UITableViewDataSource
{
    func switchGroup(_ group:ReportGroupModel) {
        switchBtn.setTitle(group.name, for: .normal)
        tableView.isScrollEnabled  = true
        groupId = group.Id
        pageIndex = 1
        if groupId == "0" {
            loadFlagData()
            loadTaskData(status: 2)
        }
        if groupId == "1" {
            loadTypeData()
            loadPatrolData(taskStatus: 0)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupId == "0" {
            return dataArray.count
        }
        if groupId == "1" {
            return patrolArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if groupId == "0" {
            let cell:ReportTaskInfoCell = tableView.dequeueReusableCell(withIdentifier: "ReportTaskInfoCell") as! ReportTaskInfoCell
            cell.model = dataArray[indexPath.row]
            return cell
        }else{
            let cell:ReportPatrolInfoCell = tableView.dequeueReusableCell(withIdentifier: "ReportPatrolInfoCell") as! ReportPatrolInfoCell
            cell.model = patrolArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ReportUserDetailController
{
    func loadFlagData() {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "LoginUserId":JHBaseInfo.userID,
                                  ]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/QuestionRevise/v3/GetStatisticalData")
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
                let rawData = try! json["Data"]["StatisticaData"].rawData()
                let tasks:[FlagStatusModel] = FlagStatusModel.parsed(data: rawData)
                for item in tasks {
                    let title = "\(item.statisticaDesc)(\(item.statisticaCount))"
                    if item.statisticaStatus == 2 {
                        //待检查
                        weakSelf.segmentedControl.setTitle(title, forSegmentAt: 0)
                    }
                    if item.statisticaStatus == 3 {
                        //超期未查
                        weakSelf.segmentedControl.setTitle(title, forSegmentAt: 1)
                    }
                    if item.statisticaStatus == 4 {
                        //已完成
                        weakSelf.segmentedControl.setTitle(title, forSegmentAt: 2)
                    }
                }
                weakSelf.loadTaskData(status: 2)
            }else{
                let msg = json["exceptionMsg"].stringValue
                //                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
    func loadTypeData() {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "LoginUserId":JHBaseInfo.userID,
                                  "UserId":userId,
                                  "CompleteUserIds":[userId],
                                  "PageIndex":userId,
                                  "PageSize":userId,
                                  "TaskState":"",
                                  "TaskId":""]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/PatrolManageRevise/v2/GetPatrolTaskListForCount")
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
            let result = json["IsSuccess"].boolValue
            if result {
                let content = json["Content"]
                let waitCheck = "待巡查(\(content["WaitCheck"]))"
                let noCheck = "超期未巡查(\(content["NoCheck"]))"
                let checked = "已巡查(\(content["Checked"]))"
                weakSelf.segmentedControl.setTitle(waitCheck, forSegmentAt: 0)
                weakSelf.segmentedControl.setTitle(noCheck, forSegmentAt: 1)
                weakSelf.segmentedControl.setTitle(checked, forSegmentAt: 2)
            }else{
                let msg = json["exceptionMsg"].stringValue
                //                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
    //taskStatus0待检查 1超期未查 2已检查
    func loadPatrolData(taskStatus:Int) {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "LoginUserId":JHBaseInfo.userID,
                                  "UserId":userId,
                                  "CompleteUserIds":[userId],
                                  "PageIndex":userId,
                                  "PageSize":userId,
                                  "TaskState":taskStatus,
                                  "TaskId":""]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/PatrolManageRevise/v2/GetPatrolTaskList")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            weakSelf.tableView.es.stopLoadingMore()
            weakSelf.tableView.es.stopPullToRefresh()
            guard let data = response.data else {
                //                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsCompleted"].boolValue
            if result {
                let rawData = try! json["Datas"].rawData()
                let tasks:[PatrolTaskModel] = PatrolTaskModel.parsed(data: rawData)
                if weakSelf.pageIndex == 1 {
                    weakSelf.dataArray.removeAll()
                }
                if tasks.count > 0 {
                    if tasks.count < 20 {
                        weakSelf.tableView.es.noticeNoMoreData()
                    }
                    weakSelf.patrolArray += tasks
                }
                
                if weakSelf.dataArray.count > 0 {
                    weakSelf.tableView.reloadData()
                    weakSelf.pageIndex += 1
                    weakSelf.hideEmptyView()
                }else{
                    weakSelf.pageIndex = 1
                    weakSelf.showNoDataView()
                }
            }else{
                let msg = json["exceptionMsg"].stringValue
                //                MBProgressHUD.displayError(kInternetError)
                weakSelf.pageIndex = 1
                weakSelf.showNoDataView()
            }
        }
    }
    
    ///2:待检查 3:超期未查 4:已完成
    func loadTaskData(status:Int) {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "LoginUserId":JHBaseInfo.userID,
                                  "ChooseUserId":userId,
                                  "PageIndex":1,
                                  "PageSize":20,
                                  "QuestionStatus":status,
                                  "QuestionSource":1]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/QuestionRevise/v3/GetByQuestionStatus")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            weakSelf.tableView.es.stopLoadingMore()
            weakSelf.tableView.es.stopPullToRefresh()
            guard let data = response.data else {
                //                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsCompleted"].boolValue
            if result {
                let rawData = try! json["Data"]["Datas"].rawData()
                let tasks:[ReportTaskModel] = ReportTaskModel.parsed(data: rawData)
                if weakSelf.pageIndex == 1 {
                    weakSelf.dataArray.removeAll()
                }
                if tasks.count > 0 {
                    if tasks.count < 20 {
                        weakSelf.tableView.es.noticeNoMoreData()
                    }
                    weakSelf.dataArray += tasks
                }
                
                if weakSelf.dataArray.count > 0 {
                    weakSelf.tableView.reloadData()
                    weakSelf.pageIndex += 1
                    weakSelf.hideEmptyView()
                }else{
                    weakSelf.pageIndex = 1
                    weakSelf.showNoDataView()
                }
            }else{
                let msg = json["exceptionMsg"].stringValue
                //                MBProgressHUD.displayError(kInternetError)
                weakSelf.pageIndex = 1
                weakSelf.showNoDataView()
            }
        }
    }
}


// 用户数据
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
