//
//  JHHandlePictureViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/9.
//

import Foundation
import JHBase
import SwiftyJSON
import MBProgressHUD

class JHHandlePictureViewController: JHHandlerCoverPicsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callImages(imageCount: 1)
    }
    
    //TODO: 添加环境图片
    override func sureAction() {
        for item in dataArray {
            if let desc = item.ambientDesc, desc.isEmpty {
//                MBProgressHUD.displayError("请编写图片描述")
                return
            }
        }
        
        var addAmbient = AddambientM()
        addAmbient.storeId = storeId
        addAmbient.type = "2"
        addAmbient.ambientList = dataArray.compactMap{ item -> AmbientModel? in
            let model = AmbientModel(ambientDesc: item.ambientDesc, ambientUrl: item.ambientURL)
            return model
        }
        let param = addAmbient.toParams()
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Store/SubmitAmbient")
//        MBProgressHUD.showText("", animated: true)
        let request = JN.post(urlStr, parameters: param, headers: nil)
        request.response {[weak self] response in
//            MBProgressHUD.hideHUDanimated(true)
            guard let weakSelf = self else { return }
            guard let data = response.data else {
//                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            if result {
                NotificationCenter.default.post(name: .init(rawValue: "JHPhotoBase_refreshList"), object: nil)
                weakSelf.backBtnClicked(UIButton())
            }else{
                let msg = json["Message"].stringValue
//                MBProgressHUD.displayError(msg)
            }
        }
    }
}
