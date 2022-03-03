//
//  JHMornInspecterController.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/20.
//

import JHBase
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

fileprivate extension Selector {
//    static let cameraClick = #selector(JHMornInspecterController.startFaceAction)
    static let cameraClick = #selector(JHMornInspecterController.startCamera(_:))

}


class JHMornInspecterController: JHBaseNavVC {
    
    var checkArr:[JHMornUploadModel]!
    
    var orgId: String{
        let key = JHBaseInfo.userID+"_CKDefaultStore"
        let storeDic = UserDefaults.standard.dictionary(forKey: key)
        guard let orgid = storeDic?["orgId"] else { return ""}
        return orgid as! String
    }
    
    var storeAppId:String{
        let key = JHBaseInfo.userID+"_CKDefaultStore"
        let storeDic = UserDefaults.standard.dictionary(forKey: key)
        guard let appId = storeDic?["appId"] else { return ""}
        return appId as! String
    }
    var storeId:String{
        let key = JHBaseInfo.userID+"_CKDefaultStore"
        let storeDic = UserDefaults.standard.dictionary(forKey: key)
        guard let appId = storeDic?["storeId"] else { return ""}
        return appId as! String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "晨检机"
        createView()
        installOHHTTPStubs()
        
        let hand = JHMornUploadModel()
        hand.tip = "请进行手部卫生拍摄"
        hand.icon = "morincheckhander"
        let cloth = JHMornUploadModel()
        cloth.tip = "请进行工作衣帽拍摄"
        cloth.icon = "mornchecktouxiang"
        checkArr = [hand,cloth]
    }
}

extension JHMornInspecterController
{
    func createView() {
        let title = UILabel()
        title.text = "请进行人脸识别"
        title.textColor = UIColor.k2F3856
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let imageView = UIImageView(image: UIImage(named: "mornfaceimage"))
        let faceBtn = UIButton()
        faceBtn.layer.cornerRadius = 22.5
        faceBtn.layer.masksToBounds = true
        faceBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        faceBtn.setTitle("去识别", for: .normal)
        faceBtn.backgroundColor = UIColor.initWithHex("07C58F")
        faceBtn.addTarget(self, action: .cameraClick, for: .touchDown)
        
        self.view.addSubview(title)
        self.view.addSubview(imageView)
        self.view.addSubview(faceBtn)
        
        title.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.navBar.snp.bottom).offset(60)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 250, height: 300))
        }
        
        faceBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-kEmptyBottomHeight - 20)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.left.equalTo(25)
        }
    }
    
    @objc func startCamera(_ btn:UIButton) {
        let vc = JHMornUpPhotoController()
        vc.checkArr = checkArr
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// 网络请求
extension JHMornInspecterController
{    
    // 人脸识别
    @objc func startFaceAction() {
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_ebc", path: "/Jinher.AMP.EBC.SV.EmployeeQuerySV.svc/GetEmployeeFaceInfoByOrgIdUserId")
        
        let userId = JHBaseInfo.userID
        let orgId = JHBaseInfo.orgID
        let requestDic = ["userId":userId,"orgId":orgId]
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: requestDic, headers: nil)
        request.response { response in
            let json = JSON(response.data!)
            print(json)
            hud.hide(animated: false)
        }
    }
}

extension JHMornInspecterController:JHMornUploadPhotoDelegate
{
    func afterUpload(_ imgmodel: [JHMornUploadModel], complated: Bool) {
        submit()
    }
    
    func submit() {
        let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/api/MorningCheck/SaveMorningCheckImg")
        
        let hand = checkArr[0]
        let cloth = checkArr[1]
        let userId = JHBaseInfo.userID
        let orgId = JHBaseInfo.orgID
        let requestDic = ["UserId":userId,
                          "OrgId":orgId,
                          "SubId":userId,
                          "HandCheckImg":hand.url,
                          "WorkclothesCheckImg":cloth.url,
        ]
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: requestDic)
        request.response { response in
            //
            let json = JSON(response.data!)
            let success = json["IsSuccess"].boolValue
            if success {
                self.requestAuthenticationType()
            }else{
                print("图片上传失败")
            }
            hud.hide(animated: false)
        }
    }
    
    func requestAuthenticationType() {
        let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/api/MorningCheck/GetMorningCheckSettingByStoreId")
        let requestDic = ["storeId":"sskks"]
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: requestDic)
        request.response { response in
            //
            let json = JSON(response.data!)
            let success = json["IsSuccess"].boolValue
            if success {
                let stepCode:[String] = json["Content"]["StepCode"].rawValue as! [String]
                self.toAuthentication(stepCode)
            }else{
                print("响应失败")
            }
            hud.hide(animated: false)
        }
    }
    
    func toAuthentication(_ stepCode:[String]) {
        //TODO: 金和浏览器
    }
}
