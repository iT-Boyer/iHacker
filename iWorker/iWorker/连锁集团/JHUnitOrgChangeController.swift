//
//  JHUnitOrgChangeController.swift
//  iWorker
//
//  Created by boyer on 2022/2/7.
//
import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class JHUnitOrgChangeController: JHUnitOrgSearchController {
    var chainId:String!
    fileprivate var changeModel:JHUnitOrgBaseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func commitAction(_ btn: UIButton) {
        let commitArr = self.dataArray.filter {($0.selected ?? false)}
        if commitArr.count == 0 {
            return
        }
        self.changeModel = commitArr[0]
        
        let commit = JHUnitOrgAlertController(title: "", message: "确认更改该企业?", image: UIImage(), style: .JHAlertControllerStyleAlert)
        let cancel = JHAlertAction("取消", style: .JHAlertActionStyleDefault)
        cancel.titleLabel?.font = .systemFont(ofSize: 16)
        cancel.setTitleColor(.initWithHex("272727"), for: .normal)
        cancel.backgroundColor = .initWithHex("F6F6F6")
        cancel.layer.masksToBounds = true
        cancel.layer.cornerRadius = 19
        
        let ok = JHAlertAction.init("更改", style: .JHAlertActionStyleDefault) {
            self.modifyFirmChain()
        }
        ok.titleLabel?.font = .systemFont(ofSize: 16)
        ok.setTitleColor(.white, for: .normal)
        ok.backgroundColor = .initWithHex("04A174")
        ok.layer.masksToBounds = true
        ok.layer.cornerRadius = 19
        
        commit.addAction(action: cancel)
        commit.addAction(action: ok)
        self.present(commit, animated: true, completion: nil)
    }
    
    func modifyFirmChain() {
        let urlStr = JHBaseDomain.fullURL(with: "api_host_patrol", path: "/api/Simple/ModifyFirmChain")
        let requestDic = ["chainId":self.chainId ?? "", //绑定关系数据ID
                          "storeId":self.storeId ?? "",
                          "bindId":self.changeModel.storeId ?? "", //新绑定的门店ID
                          "state":(self.isAddChild ? 1 : 2), //1:更换我的上级 2:添加我的下级
                          "account": JHBaseInfo.userAccount
                        ] as [String : Any]
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        let request = JN.post(urlStr, parameters: requestDic, headers: nil)
        request.response { response in
            let json = JSON(response.data!)
            let result = json["IsSuccess"].boolValue
            if result {
                if let del = self.delegate {
                    del.refeshChainDataWhenChange()
                    self.backBtnClicked(UIButton())
                }
            }else{
                let msg = json["Message"].stringValue
                let alertView = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
                var attr = AttributedString(msg)
                attr.font = .systemFont(ofSize: 16)
                attr.foregroundColor = .init(hexString: "333333")
                alertView.setValue(NSAttributedString(attr), forKey: "attributedMessage")
                let cancel = UIAlertAction.init(title: "我知道了", style: .default, handler: nil)
                alertView.addAction(cancel)
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
}
