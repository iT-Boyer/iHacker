//
//  CheckSelfSecondViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import SwiftyJSON
import JHBase
import MBProgressHUD

class CheckSelfSecondViewController: JHSelCheckBaseController {

    var typeId:String?
    var dataArray:[InspectOptionModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createView() {
        super.createView()
        setStepImage(img: "Inspect步骤2")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(JHInspectBaseCell.self, forCellReuseIdentifier: "JHInspectBaseCell")
    }
    
    override func loadData() {
        super.loadData()
        let param:[String:Any] = ["commonParam":["appId": JHBaseInfo.appID,
                                                 "userId": JHBaseInfo.userID,
                                                 "storeId":storeId,
                                                 "selfInspectTypeId":typeId
                                                ]
                                 ]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_rips", path: "/Jinher.AMP.RIP.SV.ComInspectAssistantSV.svc/GetSelfInspectOptions")
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
            hud.hide(animated: true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
                VCTools.toast("数据错误")
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            if result {
                guard let rawData = try? json["Content"].rawData() else {return}
                guard let options:[InspectOptionModel] =  InspectOptionModel.parsed(data: rawData) else { return }
                weakSelf.dataArray = options
                weakSelf.tableView.reloadData()
            }else{
                let msg = json["message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
}

extension CheckSelfSecondViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JHInspectBaseCell") as! JHInspectBaseCell
        cell.model = dataArray[indexPath.row]
        return cell
    }
}
