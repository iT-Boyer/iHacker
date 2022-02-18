//
//  JHDeviceInvitedController.swift
//  iWorker
//
//  Created by boyer on 2022/2/18.
//

import UIKit
import JHBase
import MBProgressHUD
import SwiftyJSON
import SwifterSwift

class JHDeviceInvitedController: UIViewController {

    private var alertView: UIView!
    private var alertMessage: UILabel!
    private var inviteBtn: UIButton!
    private var alertTitle: UILabel!
    
    private var inviteCode:String! //邀请码
    private var inviter:String! //邀请人
    private var deviceName:String! = "" //信息
    
    var params:JSON!
    
    /// 计算属性：富文本
    private var msgAttr:NSAttributedString{
        let attrString = NSMutableAttributedString(string: "给您分享了\(deviceName!)")
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold),
                                                    .foregroundColor: UIColor(hexString: "146FD1")!]
        
        attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
        
        let strSubAttr1: [NSMutableAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12),
                                                                 .foregroundColor: UIColor(hexString: "2F3856")!]
        
        attrString.addAttributes(strSubAttr1, range: NSRange(location: 0, length: 5))
        return attrString
    }

    override var modalPresentationStyle: UIModalPresentationStyle{
        set{
            super.modalPresentationStyle = newValue
        }
        get{
            .overCurrentContext
        }
    }
    override func viewDidLoad() {
        //设置为半透明样式
        createView()
        alertTitle.text = params["UserName"].string
        deviceName = params["DeviceName"].string
        alertMessage.attributedText = msgAttr
    }
    
    /// 接受邀请
    @objc func inviteAction() {
        //TODO: 接受邀请APi
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/IOTDeviceInvite/AddInviteUser")
        let requestDic = ["UserId":JHBaseInfo.userID,
                          "InviteCode": inviteCode ?? ""
                        ] as [String : Any]
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: requestDic, headers: nil)
        request.response { [weak self] response in
            guard let weakSelf = self else { return }
            hud.hide(animated: true)
            guard let data = response.data else {
//                MBProgressHUD.displayError(kInternetError)
                return
            }
            let json = JSON(data)
            let result = json["IsSuccess"].boolValue
            if result {
                self?.dismiss(animated: true, completion: {
                    weakSelf.toDeviceVC()
                })
            }else{
                //TODO: 邀请码失效提示
                let msg = json["Message"].stringValue
//                MBProgressHUD.displayError(msg)
                weakSelf.closeAction()
            }
        }
    }
    /// 关闭弹框
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
 
    func toDeviceVC() {
        //TODO: 进入智能设备列表
        var baseUrl = JHBaseDomain.fullURL(with: "api_host_tpwx", path: "/HMView/MorningCheckExam/?jhParams=[userId|appId|sessionId|account|orgId|changeOrg|curChangeOrg]&jhWebView=1&hidjhnavigation=1&mcn=")
        if JHBaseDomain.environment.count > 0 {
            baseUrl = JHBaseDomain.fullURL(with: "api_host_ntpp", path: "/HMView/MorningCheckExam/?jhParams=[userId|appId|sessionId|account|orgId|changeOrg|curChangeOrg]&jhWebView=1&hidjhnavigation=1&mcn=")
        }
//        let htmlUrl = baseUrl + mcn
//        let web = JHWebviewManager.getWebViewController(withURL: htmlUrl, isShowReturnButtonAndCloseButton: true, title: "", andHasTabbar: false)
//        self.navigationController?.pushViewController(web!, animated: true)
    }

    func createView() {
        //
        self.view.backgroundColor = .init(white: 0, alpha: 0.5)
        alertView = UIView()
        alertView.backgroundColor = .clear
        alertTitle = UILabel()
        alertTitle.textAlignment = .center
        alertTitle.font = .systemFont(ofSize: 16, weight: .bold)
        alertTitle.textColor = .initWithHex("2F3856")
        alertMessage = UILabel()
        alertMessage.textAlignment = .center
        alertMessage.font = .systemFont(ofSize: 12)
        alertMessage.textColor = .initWithHex("2F3856")
        let submsgLab = UILabel()
        submsgLab.textAlignment = .center
        submsgLab.font = .systemFont(ofSize: 12)
        submsgLab.textColor = .initWithHex("2F3856")
        submsgLab.text = "邀请您一起管理设备"
        let imageBg = UIImageView(image: .init(named: "invitebg"))
        inviteBtn = UIButton()
        inviteBtn.setTitle("接受邀请", for: .normal)
        inviteBtn.layer.cornerRadius = 6
        inviteBtn.layer.masksToBounds = true
        inviteBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        inviteBtn.backgroundColor = .initWithHex("146FD1")
        let closeBtn = UIButton()
        closeBtn.setImage(.init(named: "inviteclose"), for: .normal)
        
        //事件
        inviteBtn.addTarget(self, action: #selector(inviteAction), for: .touchDown)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchDown)
        
        view.addSubview(alertView)
        view.addSubview(closeBtn)
        alertView.addSubview(imageBg)
        alertView.addSubview(alertTitle)
        alertView.addSubview(alertMessage)
        alertView.addSubview(submsgLab)
        alertView.addSubview(inviteBtn)
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(48)
        }
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        imageBg.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 280, height: 240))
        }
        alertTitle.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(40)
            make.height.equalTo(22)
            make.centerX.equalToSuperview()
        }
        alertMessage.snp.makeConstraints { make in
            make.top.equalTo(alertTitle.snp.bottom).offset(20)
            make.left.equalTo(40)
            make.centerX.equalToSuperview()
        }
        submsgLab.snp.makeConstraints { make in
            make.top.equalTo(alertMessage.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.centerX.equalToSuperview()
        }
        inviteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 120, height: 36))
            make.bottom.equalToSuperview().offset(-30)
        }
        
    }
}
