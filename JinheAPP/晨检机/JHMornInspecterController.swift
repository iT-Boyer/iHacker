//
//  JHMornInspecterController.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/20.
//

import JHBase
import UIKit
import Alamofire
import OHHTTPStubs
import OHHTTPStubsSwift
import SwiftyJSON
import MBProgressHUD

fileprivate extension Selector {
    static let cameraClick = #selector(JHMornInspecterController.startFaceAction)
//    static let cameraClick = #selector(JHMornInspecterController.startCamera(_:))
//    static let cyanButtonClick = #selector(ViewController.cyanButtonClick)
}


class JHMornInspecterController: JHBaseNavVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "晨检机"
        createView()
        installOHHTTPStubs()
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
            make.bottom.equalTo(-kEmptyBottomHeight)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.left.equalTo(25)
        }
    }
    
    @objc func startCamera(_ btn:UIButton) {
        print("去识别...")
    }
}

// 网络请求
extension JHMornInspecterController
{
    // 模拟数据
    func installOHHTTPStubs(){
        let host = JHBaseDomain.domain(for: "api_host_ebc")
        stub(condition: isHost(host)) { request in
          // Stub it with our "wsresponse.json" stub file
            let urlStr = request.url?.path
            let fileName = urlStr!.lastPathComponent+".json"
            
            let stubReponse = HTTPStubsResponse(
                fileAtPath: OHPathForFile(fileName, type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
            // 模拟弱网
            stubReponse.requestTime(3, responseTime: 2)
            return stubReponse
        }
    }
    
    // 人脸识别
    @objc func startFaceAction() {
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_ebc", path: "/Jinher.AMP.EBC.SV.EmployeeQuerySV.svc/GetEmployeeFaceInfoByOrgIdUserId")
        
        let userId = JHBaseInfo.userID
        let orgId = JHBaseInfo.orgID
        let requestDic = ["userId":userId,"orgId":orgId]
        
        var response: DataResponse<Data?, AFError>?
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        AF.request(urlStr, parameters: requestDic)
            .response { resp in
                response = resp
                let json = JSON(resp.data)
                print(json)
                hud.hide(animated: false)
            }
    }
}
