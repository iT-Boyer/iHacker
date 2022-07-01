//
//  InsOptDetailViewController.swift
//  iWorker
//
//  Created by boyer on 2022/6/24.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class InsOptDetailViewController: JHBaseNavVC {

    var insOptId:String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createView()
        loadData()
    }
    
    func loadData() {
        let param:[String:Any] = ["commonParam":["appId":JHBaseInfo.appID,
                                                 "userId": JHBaseInfo.userID,
                                                 "Id": insOptId ?? ""
                                                ]
                                 ]
        let urlStr = JHBaseDomain.fullURL(with: "api_host_rips", path: "/Jinher.AMP.RIP.SV.ComInspectAssistantSV.svc/GetSelfInspectOptionDes")
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
            if result && json["Content"].exists() {
                let content = json["Content"]
                let picture = content["Picture"].stringValue
                let mark = content["Remark"].stringValue
                let title = content["Text"].stringValue
                weakSelf.titleLab.text = title
                weakSelf.detailLab.text = mark
                weakSelf.imageView.kf.setImage(with: URL(string: picture))
            }else{
                let msg = json["message"].stringValue
                VCTools.toast(msg)
            }
        }
    }
    
    func createView() {
        navTitle = "说明"
        view.backgroundColor = .white
        view.addSubviews([titleLab, detailLab, imageView])
        titleLab.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalTo(15)
        }
        detailLab.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.equalTo(15)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(detailLab.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 268, height: 310))
        }
    }
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 18)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.textColor = .k333333
        return lab
    }()
    
    lazy var detailLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .k999999
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
}
