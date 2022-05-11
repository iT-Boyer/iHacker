//
//  PhoneAccountBindViewController.swift
//  iWorker
//
//  Created by boyer on 2022/5/11.
//

import UIKit
import JHBase

class PhoneAccountBindViewController: JHBaseNavVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navTitle = "手机绑定"
        createView()
    }
    func createView() {
        let tipLab = UILabel()
        let descLab = UILabel()
        
        tipLab.font = .systemFont(ofSize: 20, weight: .bold)
        tipLab.textColor = .initWithHex("2F3856")
        tipLab.text = "请输入您的手机号"
        descLab.font = .systemFont(ofSize: 14)
        descLab.textColor = .initWithHex("99A0B6")
        descLab.numberOfLines = 0
        descLab.text = "手机绑定，需要输入您要绑定的手机号，系统会发送验证码到您的手机，请输入收到的验证码进行确认，绑定后您可以通过手机号进行登录"
        
        view.addSubviews([tipLab, descLab])
        
        let phone = UILabel()
        let code = UILabel()
        phone.text = "手机号"
        phone.textColor = .initWithHex("2F3856")
        phone.font = .systemFont(ofSize: 14)
        code.text = "验证码"
        code.textColor = .initWithHex("2F3856")
        code.font = .systemFont(ofSize: 14)
        
        view.addSubviews([phone,phoneField,code,codeField])
        
        tipLab.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(15)
            make.left.equalTo(12)
        }
        descLab.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(tipLab.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        phone.snp.makeConstraints { make in
            make.top.equalTo(descLab.snp.bottom).offset(40)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        phoneField.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
            make.top.equalTo(phone.snp.bottom).offset(15)
        }
        code.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).offset(15)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        codeField.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
            make.top.equalTo(code.snp.bottom).offset(15)
        }
    }
    
    lazy var phoneField: UITextField = {
        let tf = UITextField()
        tf.textColor = .initWithHex("2F3856")
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor:UIColor.initWithHex("B5B5B5")]
        tf.attributedPlaceholder = NSAttributedString(string: "请输入手机号", attributes: attributes)
        return tf
    }()
    lazy var codeField: UITextField = {
        let tf = UITextField()
        tf.textColor = .initWithHex("2F3856")
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor:UIColor.initWithHex("B5B5B5")]
        tf.attributedPlaceholder = NSAttributedString(string: "请输入验证码", attributes: attributes)
        return tf
    }()
}
