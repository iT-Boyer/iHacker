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
    
    // 判断是否位合法码
    static func isValid(_ code:String) -> Bool {
        // 邀请code
        if code.contains("invitecode=") {
            return true
        }
        // 设备code: 15位数字，即为合法SN号。
        let rules = NSPredicate(format: "SELF MATCHES %@", "^[0-9A-Za-z]{15}$")
        let isNumber: Bool = rules.evaluate(with: code)
        if isNumber {
            return true
        }
        return false
    }
    
    //获取邀请码对应信息--同时验证是否过期
    static func inviteInfo(_ data:String) {
        //TODO: swift 解析http参数
        // URL支持汉字：需要编码，否则在转String转URL为nil 。 解码 data.removingPercentEncoding!
        let dataStr = data.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let paramDic = URL(string: dataStr)?.queryParameters else {
            return
        }
        // static 方法 通知验证
        NotificationCenter.default.addObserver(self, selector: #selector(toDeviceH5ListVC), name: NSNotification.Name("toDeviceH5ListVCKey"), object: nil)
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/api/IOTDeviceInvite/GetInviteInfo")
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
    
    //MARK: 邀请的设置页面
    @objc
    public static func deviceSeting(_ deviceId:String) {
        //
        let deviceSetting = JHPriDeviceSetingController()
        deviceSetting.deviceId = deviceId
        let nav = UINavigationController(rootViewController: deviceSetting)
        UIViewController.topVC?.present(nav, animated: true, completion: nil)
    }
    
    @objc
    public static func mornInspecter()->AnyClass{
        return JHMornInspecterController.self
    }
    
    @objc
    static func toDeviceH5ListVC() {
        //进入智能设备列表
        let params = "/ui/moblie/#/IOTEquipment?&jhParams=[userId|sessionId|orgId|appId|changeOrg|curChangeOrg|account]&jhWebView=1&hideShare=1&hidjhnavigation=1"
        var baseUrl = JHBaseDomain.fullURL(with: "api_host_ripx-ui", path: params)
        if JHBaseDomain.environment.count > 0 {
            baseUrl = JHBaseDomain.fullURL(with: "api_host_ripx", path: params)
        }
//        JHWebviewManager.pushWebViewController(withURL: baseUrl, isShowReturnButtonAndCloseButton: false, title: "")
    }
}
