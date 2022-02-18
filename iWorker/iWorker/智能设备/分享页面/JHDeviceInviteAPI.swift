//
//  JHDeviceInviteAPI.swift
//  iWorker
//
//  Created by boyer on 2022/2/18.
//

import Foundation
import JHBase
import SwiftyJSON
import MBProgressHUD

class JHDeviceInviteAPI: NSObject {
    
    //获取邀请码对应信息--同时验证是否过期
    static func inviteInfo(_ data:String) {
        //TODO: swift 解析http参数
        // URL支持汉字：需要编码，否则在转String转URL为nil 。 解码 data.removingPercentEncoding!
        let dataStr = data.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let paramDic = URL(string: dataStr)?.queryParameters else {
            return
        }
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/IOTDeviceInvite/GetInviteInfo")
        let code = paramDic["invitecode"]
        let requestDic = ["UserId":JHBaseInfo.userID,
                          "InviteCode": code ?? ""
                        ] as [String : Any]
        
        let request = JN.post(urlStr, parameters: requestDic, headers: nil)
        request.response {response in
            
//            hud.hide(animated: true)
            guard let data = response.data else {
//                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            if result {
                let content:JSON = json["Content"]
                let isOK = content["isOK"].boolValue
                //显示邀请弹框
                if isOK {
                    let inviteVC = JHDeviceInvitedController()
                    inviteVC.params = content
                    UIViewController.topVC?.present(inviteVC, animated: true, completion: nil)
                }else{
                    //TODO: 邀请码失效提示
                    //MBProgressHUD.displayError(msg)
                }
            }else{
                //TODO: 错误提示
                let msg = json["Message"].stringValue
//                MBProgressHUD.displayError(msg)
            }
        }
    }
}
