//
//  JHCreateVideoActController.swift
//  iWorker
//
//  Created by boyer on 2022/4/27.
//

import UIKit
import JHBase
import SwiftyJSON
import MBProgressHUD

class JHCreateVideoActController: JHAddActivityBaseController {

    var activityName = ""
    var photoUrl = ""
    var startTime = ""
    var endTime = ""
    var note = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navTitle = "添加活动"
    }

    func saveAction() {
        
        guard activityName.count > 0, note.count > 0, photoUrl.hasPrefix("https"), startTime.count > 0, endTime.count > 0 else {
//            MBProgressHUD.displayError("请先完善活动信息")
            return
        }
        
        let formater = DateFormatter()
        formater.dateFormat = "YYYY年MM月dd日"
        let start = formater.date(from: startTime)
        let end = formater.date(from: endTime)
        let result = start?.compare(end!)
        if (result == .orderedDescending) {
            VCTools.toast("开始时间不能晚于结束时间")
            return
        }
        
        let param:[String:Any] = ["OrgId":JHBaseInfo.orgID,
                                  "AppId":JHBaseInfo.appID,
                                  "UserId":JHBaseInfo.userID,
                                  "UserName":JHBaseInfo.userAccount,
                                  "ActivityName":activityName,
                                  "ActivityImagePath":photoUrl,
                                  "ActivityStartDate":startTime,
                                  "ActivityEndDate":endTime,
                                  "ActivityPath":note]
        
        let urlStr = JHBaseDomain.fullURL(with: "api_host_imv", path: "/api/Activity/Add")
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
                weakSelf.backBtnClicked(UIButton())
            }else{
                let msg = json["Message"].stringValue
//                MBProgressHUD.displayError(kInternetError)
            }
        }
    }
    
    override func createView() {
        super.createView()
        
        field.delegate = self
        textView.delegate = self
        field.addTarget(self, action: #selector(textFieldDidChangeValue(textField:)), for: .editingChanged)
        
        navBar.backBtn.isHidden = true
        let cancel = UIButton()
        cancel.setTitle("取消", for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 14)
        cancel.setTitleColor(.initWithHex("333333"), for: .normal)
        cancel.jh.setHandleClick {[unowned self] button in
            cancelAction()
        }
        let save = UIButton()
        save.setTitle("发布", for: .normal)
        save.titleLabel?.font = .systemFont(ofSize: 14)
        save.setTitleColor(.initWithHex("428BFE"), for: .normal)
        save.jh.setHandleClick { button in
            
        }
        
        navBar.addSubviews([cancel, save])
        
        cancel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.size.equalTo(CGSize(width: 30, height: 20))
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
        }
        
        save.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.size.equalTo(CGSize(width: 30, height: 20))
            make.centerY.equalTo(navBar.titleLabel.snp.centerY)
        }
    }
    
    func cancelAction() {
        view.endEditing(true)
        let alert = UIAlertController(title: nil, message: "您确定放弃发布活动吗?", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "确定", style: .default) {[unowned self] action in
            backBtnClicked(UIButton())
        }
        let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension JHCreateVideoActController:UITextFieldDelegate{
    
    func textFieldDidChangeValue(textField:UITextField) {
        guard let toBeString = textField.text else {
            return
        }
        if toBeString.count > 20 {
            textField.text = "\(toBeString.suffix(20))"
        }
    }
}

extension JHCreateVideoActController:UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = "活动内容介绍"
            textView.textColor = .initWithHex("99A0B6")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "活动内容介绍" {
            textView.text = ""
            textView.textColor = .initWithHex("2F3856")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        if text.isEmpty == true
            && range.location == 0
            && range.length == 1{
            return false
        }
        
        if range.location >= 120{
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let limit = 1000
        if textView.text.count > limit {
            textView.text = String(textView.text.prefix(limit))
            textView.undoManager?.removeAllActions()
            textView.becomeFirstResponder()
            return
        }
    }
}
