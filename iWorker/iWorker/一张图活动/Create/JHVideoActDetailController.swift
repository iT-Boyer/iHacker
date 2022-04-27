//
//  JHVideoActDetailController.swift
//  iWorker
//
//  Created by boyer on 2022/4/27.
//

import UIKit
import JHBase
import Kingfisher
import SwiftyJSON
import MBProgressHUD

class JHVideoActDetailController: JHAddActivityBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        field.isUserInteractionEnabled = false
        textView.isUserInteractionEnabled = false
        photo.isUserInteractionEnabled = false
        startDate.isUserInteractionEnabled = false
        endDate.isUserInteractionEnabled = false
        startDate.dateBtn.isSelected = true
        endDate.dateBtn.isSelected = true
        loadDetail()
    }
    
    func loadDetail() {
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "UserId":JHBaseInfo.userID,
                                  "Id":JHBaseInfo.userAccount]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_imv", path: "/api/Activity/GetActivityInfo")
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
                let model:JHActivityModel = JHActivityModel.parsed(data: rawData)
                OperationQueue.main.addOperation {
                    if let url = URL(string: model.activityImagePath) {
                        weakSelf.photo.kf.setImage(with: url, for:.normal, placeholder: .init(named: "uploadImg"))
                    }
                    weakSelf.field.text = model.activityName
                    weakSelf.startDate.dateBtn.setTitle(model.activityStartDate, for: .selected)
                    weakSelf.endDate.dateBtn.setTitle(model.activityEndDate, for: .selected)
                    weakSelf.textView.text = model.activityPath
                }
            }else{
                let msg = json["Message"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
    
    
}
