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

    var Id:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        field.text = "活动介绍"
        field.isUserInteractionEnabled = false
        textView.isUserInteractionEnabled = false
        textView.textColor = .initWithHex("676C87")
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
                let modelJ = try! json["Data"]
                OperationQueue.main.addOperation {
                    if let url = URL(string: modelJ["ActivityImagePath"].stringValue) {
                        weakSelf.photo.kf.setImage(with: url, for:.normal, placeholder: .init(named: "uploadImg"))
                    }
                    weakSelf.navTitle = modelJ["ActivityName"].stringValue
                    weakSelf.startDate.dateBtn.setTitle(modelJ["ActivityStartDate"].stringValue, for: .selected)
                    weakSelf.endDate.dateBtn.setTitle(modelJ["ActivityEndDate"].stringValue, for: .selected)
                    weakSelf.textView.text = modelJ["ActivityPath"].stringValue
                    let note = modelJ["ActivityPath"].stringValue
                    let noteData = note.data(using: .unicode)
                    if let attributedString = try? NSAttributedString(data: noteData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                        weakSelf.textView.attributedText = attributedString
                    }
                }
            }else{
                let msg = json["Message"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
}
