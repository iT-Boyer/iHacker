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

    // 单例初始化
    static let shared = JHDeviceInviteAPI()
    // 持有bindVC页面
    var bindVC:JHBindingEditIntelDescisionVC!
    
    // 判断是否位合法码
    static func isValid(_ code:String) -> Bool {
        // 邀请code
        if code.contains("invitecode=") {
            return true
        }
        // 设备code: 15位数字，即为合法SN号。
        guard code.count == 12 || code.count == 15 else { return false}
        let rules = NSPredicate(format: "SELF MATCHES %@", "^[0-9A-Za-z]{\(code.count)}$")
        let isNumber: Bool = rules.evaluate(with: code)
        if isNumber {
            shared.bindVC = JHBindingEditIntelDescisionVC()
            shared.bindVC.navTitle = "绑定设备"
            //1  是C端 ，2 是B端 ，3 是G端
            let status = UserDefaults.standard.integer(forKey: "StoreStatus")
            if status == 2 {
                let key = JHBaseInfo.userID+"_CKDefaultStore"
                let storeDic = UserDefaults.standard.dictionary(forKey: key)
                guard let storeData = storeDic else { return false}
                let json = JSON(storeData)
                shared.bindVC.storeId = json["storeId"].stringValue
            }
            shared.bindVC.scanBind(code, type: .scanIndex)
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
    
    //MARK: 邀请设置页面判断
    @objc
    public static func invateOrSetting(storeId:String,deviceId:String) {
        //TODO: 个人时，跳转设置页面
        //1  是C端 ，2 是B端 ，3 是G端
        let status = UserDefaults.standard.integer(forKey: "StoreStatus")
        if (status == 1) {
            deviceSeting(deviceId)
        }else{
            //组织时
            let vc = JHBindingEditIntelDescisionVC()
            vc.navTitle = "基础设备"
            vc.storeId = storeId
            vc.pageType = .detail
            vc.deviceId = deviceId
            UIViewController.topVC?.present(vc, animated: true, completion: nil)
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
    
    //绑定
    @objc
    public static func bindDevice(storeId:String) {
        let vc = JHBindingEditIntelDescisionVC()
        vc.navTitle = "绑定设备"
        UIViewController.topVC?.present(vc, animated: true, completion: nil)
    }
}
