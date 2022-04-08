//
//  JHDeviceNickCell.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//

import UIKit
import JHBase

// 迁移JHBindingDeviceNameInputCell.m
class JHDeviceNickCell:JHDeviceBaseCell{//}: VBindable<JHNickViewModel> {
    
    @objc dynamic var nick:String?
    override func createView() {
        super.createView()
        titleLab.text = "设备名称"
        layoutView(first: titleLab, second: nickField)
    }
    lazy var nickField: UITextField = {
        let nick = UITextField()
        nick.delegate = self
        nick.font = .systemFont(ofSize: 14)
        nick.textColor = .initWithHex("5E637B")
        nick.returnKeyType = .done
        nick.clearButtonMode = .whileEditing
        nick.addTarget(self, action: #selector(textFieldDidChangeValue(textField:)), for: .editingChanged)
        let arr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                   .foregroundColor: UIColor(hexString: "ADADAD")!]
        nick.attributedPlaceholder = NSAttributedString(string: "主人请给我起个名字吧", attributes: arr)
        return nick
    }()
    
    @objc
    func textFieldDidChangeValue(textField:UITextField) {
        self.nick = textField.text
    }
    
    func bind(viewModel vm:JHNickViewModel){
        if kvoToken == nil {
            kvoToken = vm.observe(\.nick, options: [.new, .old]) { (model, nick) in
                let new = nick.newValue ?? ""
                print("新昵称：\(new ?? "")")
                self.nickField.text = new
            }
        }
    }
}

extension JHDeviceNickCell:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location >= 15 {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
