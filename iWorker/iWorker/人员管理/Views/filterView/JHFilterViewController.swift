//
//  ReportMapRightFilterView.swift
//  iWorker
//
//  Created by boyer on 2022/5/26.
//

import Foundation
import JHBase
import UIKit
import SwiftyJSON
import MBProgressHUD

class JHFilterViewController: JHBaseNavVC {
    
    var dataArray:[JHMapFilterM] = []
    var handlerBlock:((String?)->())!
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        loadData()
    }
    
    func createView() {
        navBar.backBtn.isHidden = true
        view.backgroundColor = .white
        
        let titleLab = UILabel()
        titleLab.text = "地图筛选"
        titleLab.textColor = .k2F3856
        titleLab.font = .systemFont(ofSize: 14)
        navBar.addSubview(titleLab)
        
        view.addSubviews([tableView,bottomView])
        
        titleLab.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.left.equalTo(12)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.centerX.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(50)
            make.left.centerX.equalToSuperview()
            make.bottom.equalTo(-kEmptyBottomHeight)
        }
        
    }
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.register(JHFilterCell.self, forCellReuseIdentifier: "JHFilterCell")
        tb.removeTableFooterView()
        tb.estimatedRowHeight = 40
        tb.rowHeight = UITableView.automaticDimension
        return tb
    }()
    
    lazy var bottomView: UIView = {
        let bottom = UIView()
        let resetBtn = UIButton()
        let sureBtn = UIButton()
        
        resetBtn.setTitle("重置", for: .normal)
        resetBtn.setTitleColor(.k99A0B6, for: .normal)
        resetBtn.titleLabel?.font = .systemFont(ofSize: 16)
        resetBtn.addShadow(ofColor: .init(white: 0, alpha: 0.23), radius: 4, offset: .zero, opacity: 0.5)
        resetBtn.jh.setHandleClick {[weak self] button in
            //TODO: 重置筛选条件
            guard let wf = self else{return}
            let model = wf.dataArray[0]
            wf.dataArray = wf.dataArray.map{ item in
                var mm = item
                mm.selected = model.id == item.id
                return mm
            }
            wf.tableView.reloadData()
        }
        
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.backgroundColor = .k3FDA7F
        sureBtn.titleLabel?.font = .systemFont(ofSize: 16)
        sureBtn.jh.setHandleClick {[weak self] button in
            //TODO: 提交筛选
            guard let wf = self else{return}
            let models:[JHMapFilterM] = wf.dataArray.filter{ $0.selected }
            wf.handlerBlock(models.first?.id)
            wf.dismiss(animated: true)
        }
        
        bottom.addSubviews([resetBtn,sureBtn])
        resetBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        sureBtn.snp.makeConstraints { make in
            make.width.equalTo(resetBtn.snp.width)
            make.left.equalTo(resetBtn.snp.right)
            make.right.top.bottom.equalToSuperview()
        }
        return bottom
    }()
}

extension JHFilterViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JHFilterCell") as! JHFilterCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        dataArray = dataArray.map{ item in
            var mm = item
            mm.selected = model.id == item.id
            return mm
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "LoginUserId":JHBaseInfo.userID
                                 ]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/Basics/GetDepartmentList")
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
                weakSelf.dataArray = JHMapFilterM.parsed(data: rawData)
                weakSelf.tableView.reloadData()
            }else{
                let msg = json["exceptionMsg"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
}
