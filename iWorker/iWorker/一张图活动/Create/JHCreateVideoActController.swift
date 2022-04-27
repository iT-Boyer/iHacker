//
//  JHCreateVideoActController.swift
//  iWorker
//
//  Created by boyer on 2022/4/27.
//

import UIKit

class JHCreateVideoActController: JHAddActivityBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            
            backBtnClicked(UIButton())
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
        let ok = UIAlertAction.init(title: "确定", style: .default) { action in
            
        }
        let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
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
