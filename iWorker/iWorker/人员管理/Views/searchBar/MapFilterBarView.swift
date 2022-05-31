//
//  MapFilterBarView.swift
//  iWorker
//
//  Created by boyer on 2022/5/25.
//

import Foundation
import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class MapFilterBarView: UIView {
    
    var handlerBlock:((ReportLastFootM?)->())
    var completedBlock:(()->())
    var placeholder:String!
    var result:ReportLastFootM!
    
    // 查询结果列表
    var dataArray:[ReportLastFootM] = []
    
    init(with placeholder:String,handler:@escaping (ReportLastFootM?)->(),completed:@escaping ()->()) {
        handlerBlock = handler
        completedBlock = completed
        super.init(frame: CGRect.zero)
        self.placeholder = placeholder
        
        createView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: NSNotification.Name("UIKeyboardWillShowNotification"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UIKeyboardWillShowNotification"), object: nil)
    }
    func createView() {
        //子视图布局
        addSubviews([backView,searchView,tableView])
        backView.snp.makeConstraints { make in
            make.left.bottom.top.right.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { make in
            make.topMargin.equalTo(20)
            make.left.equalTo(15)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.bottom.centerX.equalToSuperview()
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(120)
            make.width.equalTo(UIScreen.main.bounds.size.width)
        }
    }
    
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .init(white: 1, alpha: 0.8)
        backView.isHidden = true
        return backView
    }()
    lazy var searchView: UIView = {
        
        let searchView = UIView()
        searchView.backgroundColor = .white
        searchView.layer.cornerRadius = 4
        searchView.addShadow(ofColor: .init(white: 0, alpha: 0.23), radius: 4, offset: CGSize(width: 3, height: 6), opacity: 0.5)
       
        let backBtn = UIButton()
        backBtn.setImage(.init(named: "backicon"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchDown)
    
        searchView.addSubviews([backBtn,titleLab,searchBar,startBtn])
        
        // layout
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(backBtn.snp.right).offset(8)
            make.width.equalTo(60)
            make.centerY.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(8)
            make.height.equalTo(28)
            make.centerY.equalToSuperview()
            make.top.equalTo(10)
        }
        startBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.left.equalTo(searchBar.snp.right).offset(8)
        }
        
        return searchView
    }()
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.text = "完美社区"
        titleLab.textColor = .initWithHex("979797")
        titleLab.font = .systemFont(ofSize: 14)
        return titleLab
    }()
    
    lazy var searchBar: StoreDSelSearchBar = {
        let searchBar = StoreDSelSearchBar(with: placeholder) {[weak self] text in
            //TODO: 搜索业务
            guard let wf = self else{return}
            wf.loadData(text)
            wf.searchStatus(true)
        } clear: {[weak self] in
            guard let wf = self else{return}
            wf.searchStatus(false)
        }
        return searchBar
    }()
    lazy var startBtn: UIButton = {
        let startBtn = UIButton()
        startBtn.isHidden = true
        startBtn.setTitle("搜索", for: .normal)
        startBtn.titleLabel?.font = .systemFont(ofSize: 16)
        startBtn.setTitleColor(.initWithHex("428BFE"), for: .normal)
        startBtn.addTarget(self, action: #selector(startAction), for: .touchDown)
        return startBtn
    }()
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .clear
        tb.delegate = self
        tb.dataSource = self
        tb.separatorColor = .kEEEEEE
        tb.tableFooterView = UIView()
        tb.estimatedRowHeight = 40
        tb.rowHeight = UITableView.automaticDimension
        tb.register(ReportMapFilterCell.self, forCellReuseIdentifier: "ReportMapFilterCell")
        return tb
    }()
    
    @objc
    func showKeyboard(_ notf:Notification) {
        searchStatus(true)
    }
    func searchStatus(_ isearch:Bool) {
        // 展开，显示tableview
        if isearch {
            snp.updateConstraints { make in
                make.height.equalTo(UIScreen.main.bounds.size.height)
            }
            titleLab.snp.updateConstraints { make in
                make.width.equalTo(0)
            }
            titleLab.isHidden = true
            tableView.isHidden = false
            backView.isHidden = false
            startBtn.isHidden = false
        }else{ // 收起
            snp.updateConstraints { make in
                make.height.equalTo(120)
            }
            titleLab.snp.updateConstraints { make in
                make.width.equalTo(60)
            }
            titleLab.isHidden = false
            startBtn.isHidden = true
            tableView.isHidden = true
            backView.isHidden = true
            dataArray.removeAll()
            tableView.reloadData()
            endEditing(true)
            searchBar.searchBar.text = ""
        }
    }
    
    //MARK: - UIAction
    @objc func startAction(){
        searchBar.startSearch()
    }
    @objc func backAction(){
        if titleLab.isHidden {
            handlerBlock(nil)
            searchStatus(false)
        }else{
            completedBlock()
        }
    }
}

extension MapFilterBarView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReportMapFilterCell = tableView.dequeueReusableCell(withIdentifier: "ReportMapFilterCell") as! ReportMapFilterCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handlerBlock(dataArray[indexPath.row])
        searchStatus(false)
    }
}

extension MapFilterBarView
{
    func loadData(_ keyword:String) {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "DepartmentId":JHBaseInfo.userID,
                                  "AreaCode":"",
                                  "SearchUserName":keyword]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_scg", path: "/api/QuestionFootPrint/v3/GetLastFootPrint")
        let hud = MBProgressHUD.showAdded(to:superview!, animated: true)
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
                if json["Data"].isEmpty {return}
                let rawData = try! json["Data"].rawData()
                guard let arr:[ReportLastFootM] = ReportLastFootM.parsed(data: rawData) else { return }
                weakSelf.dataArray = arr
                weakSelf.tableView.reloadData()
            }else{
                let msg = json["exceptionMsg"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
}
