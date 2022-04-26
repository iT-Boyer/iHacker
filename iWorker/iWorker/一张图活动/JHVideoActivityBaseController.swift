//
//  JHVideoActivityBaseController.swift
//  iWorker
//
//  Created by boyer on 2022/4/22.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class JHVideoActivityBaseController: JHBaseNavVC {

    var dataArray:[JHActivityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createView()
    }
    
    func createView(){
        //导航条右边按钮
        let complate = UIButton()
        complate.setImage(.init(named: "add"), for: .normal)
        complate.jh.setHandleClick { button in
            
        }
        
        navBar.addSubview(complate)
        complate.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
            make.right.equalTo(-14)
            make.size.equalTo(CGSize.init(width: 50, height: 30))
        }
        //列表
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    //MARK: getter
    lazy var tableView = { () -> UITableView in
        let tbl = UITableView()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.showsVerticalScrollIndicator = false
        tbl.showsHorizontalScrollIndicator = false
        tbl.backgroundColor = .init(hexString: "F5F5F5")
        tbl.estimatedRowHeight = 60
        tbl.rowHeight = UITableView.automaticDimension
        tbl.tableFooterView = UIView()
        tbl.separatorStyle = .none
        return tbl
    }()
}

extension JHVideoActivityBaseController:UITableViewDataSource,UITableViewDelegate{
    
    func loadData(api:String) {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "UserId":JHBaseInfo.userID,
                                  "PageSize":20,
                                  "PageIndex":1]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_imv", path: "/api/Activity/\(api)")
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
                let rawData = try! json["Data"].rawData()
                let dataArray:[JHActivityModel] = JHActivityModel.parsed(data: rawData)
                print("解析结果：\(dataArray.count)")
                weakSelf.dataArray = dataArray
                OperationQueue.main.addOperation {
                    weakSelf.tableView.reloadData()
                }
            }else{
                let msg = json["Message"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        print("点击事件")
    }
}
