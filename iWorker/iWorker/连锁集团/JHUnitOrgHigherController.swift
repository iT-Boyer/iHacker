//
//  JHUnitOrgHigherController.swift
//  iWorker
//
//  Created by boyer on 2022/2/7.
//

import UIKit
import JHBase
import MBProgressHUD
import SwiftyJSON

class JHUnitOrgHigherController: JHUnitOrgBaseViewController {

    var chainModel:JHUnitOrgHigherModel!
    var state:Int = 0
    var operateBtn:UIButton!
    
    fileprivate var bottomView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "组织管理"
        self.state = 2
        self.storeId = "test"
        loadData(true)
    }
    
    override func createView() {
        super.createView()
        let bottom = UIView()
        bottom.backgroundColor = .white
        let delBtn = UIButton()
        self.operateBtn = delBtn
        delBtn.layer.cornerRadius = 4
        delBtn.backgroundColor = .initWithHex("04A174")
        delBtn.titleLabel?.font = .systemFont(ofSize: 18)
        delBtn.setTitleColor(.white, for: .normal)
        delBtn.setTitle("删除", for: .normal)
        delBtn.addTarget(self, action: #selector(operatection(_:)), for: .touchDown)
        view.addSubview(bottom)
        bottom.addSubview(delBtn)
        self.bottomView = bottom
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.left.right.equalTo(0)
        }
        bottom.snp.makeConstraints { make in
            make.top.equalTo(self.tableView.snp.bottom)
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(73)
        }
        
        delBtn.snp.makeConstraints { make in
            make.left.top.equalTo(12)
            make.center.equalToSuperview()
        }
        
        self.tableView.register(JHUnitOrgHigherCell.self, forCellReuseIdentifier: "JHUnitOrgHigherCell")
    }
    
    @objc
    func operatection(_ btn:UIButton) {
        self.chainModel = self.dataArray[0] as! JHUnitOrgHigherModel
        delfirmAcion()
    }
    func delfirmAcion() {
        let commit = JHUnitOrgAlertController(title: "", message: "确定删除该企业?", image: UIImage(), style: .JHAlertControllerStyleAlert)
        let cancel = JHAlertAction("取消", style: .JHAlertActionStyleDefault)
        cancel.titleLabel?.font = .systemFont(ofSize: 16)
        cancel.setTitleColor(.initWithHex("272727"), for: .normal)
        cancel.backgroundColor = .initWithHex("F6F6F6")
        cancel.layer.masksToBounds = true
        cancel.layer.cornerRadius = 19
        
        let del = JHAlertAction.init("删除", style: .JHAlertActionStyleDefault) {
            self.delFirmChain()
        }
        del.titleLabel?.font = .systemFont(ofSize: 16)
        del.setTitleColor(.white, for: .normal)
        del.backgroundColor = .initWithHex("04A174")
        del.layer.masksToBounds = true
        del.layer.cornerRadius = 19
        
        commit.addAction(action: cancel)
        commit.addAction(action: del)
        self.present(commit, animated: true, completion: nil)
    }
    
    func delFirmChain() {
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Simple/DelFirmChain")
        let requestDic = ["chainId":self.chainModel.chainId ?? "", //绑定关系数据ID
                          "storeId":self.storeId ?? "",
                          "state":state, //1:更换我的上级 2:添加我的下级
                        ] as [String : Any]
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: requestDic, headers: nil)
        request.response { [weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
//                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            let msg = json["Message"].stringValue
            if result {
                weakSelf.delAfterAction()
            }else{
                let alertView = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
                var attr:NSAttributedString!
                if #available(iOS 15, *) {
                    var attrNew = AttributedString(msg)
                    attrNew.font = .systemFont(ofSize: 16)
                    attrNew.foregroundColor = .init(hexString: "333333")
                    attr = NSAttributedString(attrNew)
                } else {
                    // Fallback on earlier versions
                    let arr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 16),
                                                                .foregroundColor: UIColor(hexString: "333333")!]
                    attr = NSAttributedString.init(string: msg, attributes: arr)
                }
                alertView.setValue(attr, forKey: "attributedMessage")
                let cancel = UIAlertAction.init(title: "我知道了", style: .default, handler: nil)
                alertView.addAction(cancel)
                weakSelf.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    func delAfterAction() {
        self.dataArray.removeAll(self.chainModel)
        self.tableView.reloadData()
        if self.dataArray.count == 0 {
            let join = JHUnitJoinOrgViewController()
            join.storeId = self.storeId
            self.navigationController?.pushViewController(join, animated: true)
        }
        loadData()
    }
    
    override func backBtnClicked(_ btn: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    override func loadData(_ isRefresh: Bool = false) {
        super.loadData(isRefresh)
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Simple/GetEnterChainList")
        let requestDic = ["appId":JHBaseInfo.appID,
                          "storeId":self.storeId ?? "",
                          "pageIndex":1,
                          "pageSize":20] as [String : Any]
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: requestDic, headers: nil)
        request.response { [weak self] response in
            hud.hide(animated: false)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
//                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            if result {
                let dataArray = json["enterChainList"].arrayValue
                let totalCount = json["totalCount"].intValue
                if dataArray.count > 0 {
                    if weakSelf.pageIndex == 1 {
                        weakSelf.dataArray.removeAll()
                    }
                    weakSelf.hideEmptyView()
                    for modelJ:JSON in dataArray {
                        var isExist = false
                        let model:JHUnitOrgHigherModel = JHUnitOrgHigherModel.parsed(data: try!modelJ.rawData()) 
                        for origin:JHUnitOrgBaseModel in weakSelf.dataArray {
                            if origin.bindId == model.bindId {
                                isExist = true
                                break
                            }
                        }
                        if !isExist {
                            weakSelf.dataArray.append(model)
                        }
                    }
                    if weakSelf.dataArray.count >= totalCount {
                        let index = totalCount/20
                        if totalCount%20>0 {
                            weakSelf.pageIndex = index + 1
                        }else{
                            weakSelf.pageIndex = index
                        }
                    }else{
                        weakSelf.pageIndex += 1
                    }
                }else{
                    if weakSelf.pageIndex == 1 {
                        weakSelf.dataArray.removeAll()
                        weakSelf.bottomView.isHidden = true
                        weakSelf.showNoDataView()
                    }
                }
                if isRefresh {
                    weakSelf.tableView.es.stopPullToRefresh()
                }else{
                    if weakSelf.dataArray.count >= totalCount {
                        weakSelf.tableView.es.noticeNoMoreData()
                    }else{
                        weakSelf.tableView.es.stopLoadingMore()
                    }
                }
                weakSelf.tableView.reloadData()
            }
        }
    }
}

extension JHUnitOrgHigherController:JHUnitOrgDelegate
{
    func refeshChainDataWhenAdd() {
        loadData()
    }
    
    func refeshChainDataWhenChange() {
        loadData()
    }
}

extension JHUnitOrgHigherController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:JHUnitOrgHigherCell = tableView.dequeueReusableCell(withIdentifier: "JHUnitOrgHigherCell") as! JHUnitOrgHigherCell
        let model:JHUnitOrgHigherModel = self.dataArray[indexPath.section] as! JHUnitOrgHigherModel
        cell.model = model
        cell.ChangeAction = {
            let change = JHUnitOrgChangeController()
            change.isAddChild = false
            change.storeId = self.storeId
            change.chainId = model.chainId
            change.delegate = self
            self.navigationController?.pushViewController(change, animated: true)
        }
        return cell
    }
}
