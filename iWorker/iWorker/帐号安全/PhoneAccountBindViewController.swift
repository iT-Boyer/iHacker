//
//  PhoneAccountBindViewController.swift
//  iWorker
//
//  Created by boyer on 2022/5/11.
//

import UIKit
import JHBase
import Combine
import SwifterSwift

class PhoneBindBaseVC: JHBaseNavVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navTitle = "手机绑定"
        createView()
    }
    
    func codeAction() {}
    
    @objc func changeTel(tf:UITextField) {}
    
    @objc func changeCode(tf:UITextField) {}
    @objc func submmit() {}
    func createView() {
        view.backgroundColor = .white
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
        
        let line = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
        line.backgroundColor = .initWithHex("EEEEEE")
        
        view.addSubviews([phone,phoneField,line,code,codeField,codeBtn,submmitBtn])
        
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
        line.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.height.equalTo(0.5)
            make.right.equalToSuperview()
        }
        code.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        codeField.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(code.snp.bottom).offset(15)
        }
        codeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(codeField)
            make.left.equalTo(codeField.snp.right)
            make.size.equalTo(CGSize(width: 110, height: 30))
            make.right.equalTo(-12)
        }
        submmitBtn.snp.makeConstraints { make in
            make.top.equalTo(codeField.snp.bottom).offset(50)
            make.left.equalTo(12)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var phoneField: UITextField = {
        let tf = UITextField()
        tf.textColor = .initWithHex("2F3856")
        tf.keyboardType = .phonePad
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor:UIColor.initWithHex("B5B5B5")]
        tf.attributedPlaceholder = NSAttributedString(string: "请输入手机号", attributes: attributes)
        tf.addTarget(self, action: #selector(changeTel(tf:)), for: .editingChanged)
        return tf
    }()
    lazy var codeField: UITextField = {
        let tf = UITextField()
        tf.textColor = .initWithHex("2F3856")
        tf.keyboardType = .phonePad
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor:UIColor.initWithHex("B5B5B5")]
        tf.attributedPlaceholder = NSAttributedString(string: "请输入验证码", attributes: attributes)
        tf.addTarget(self, action: #selector(changeCode(tf:)), for: .editingChanged)
        return tf
    }()
    lazy var codeBtn: UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.setTitle("获取验证码", for: .normal)
        btn.setTitle("获取验证码", for: .disabled)
        btn.setTitleColor(.white, for: .disabled)
        btn.setTitleColor(.initWithHex("599199"), for: .normal)
        //无效
        //let image = UIImage().filled(withColor: .initWithHex("599199", alpha: 0.1))
        let image = UIImage(color: .initWithHex("599199", alpha: 0.1), size: CGSize(width: 1, height: 1))
        let image2 = UIImage(color: .initWithHex("D8D8D8"), size: CGSize(width: 1, height: 1))
        btn.setBackgroundImage(image, for: .normal)
        btn.setBackgroundImage(image2, for: .disabled)
        btn.titleLabel?.font = .systemFont(ofSize: 13)
        btn.jh.setHandleClick {[unowned self] button in
            codeAction()
        }
        return btn
    }()
    
    lazy var submmitBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        let image = UIImage(color: .initWithHex("599199"), size: CGSize(width: 1, height: 1))
        let image2 = UIImage(color: .initWithHex("D8D8D8"), size: CGSize(width: 1, height: 1))
        btn.setBackgroundImage(image, for: .normal)
        btn.setBackgroundImage(image2, for: .disabled)
        btn.addTarget(self, action: #selector(submmit), for: .touchDown)
        return btn
    }()
}

class PhoneAccountBindViewController: PhoneBindBaseVC {
    
    var timer: Timer?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    override func submmit() {
        //手机号
        let rules = NSPredicate(format: "SELF MATCHES %@", "1\\d{10}$")
        let phone = phoneField.text ?? ""
        let isphone: Bool = rules.evaluate(with: phone)
        if !isphone{
            //手机格式不正确，请重新输入
            VCTools.toast("手机格式不正确，请重新输入")
            return
        }
        
        let coderex = NSPredicate(format: "SELF MATCHES %@", "^[0-9]{6}$")
        let code = codeField.text ?? ""
        let iscode: Bool = coderex.evaluate(with: code)
        if !iscode{
            VCTools.toast("验证码格式不正确，请重新输入")
            return
        }
    }
    
    override func codeAction() {
        var count = 120
        codeBtn.isEnabled = false
        //必须属性引用，否则正常倒计时
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] timer in
            guard let weakSelf = self else { return }
            if count == 0{
                weakSelf.codeBtn.isEnabled = true
                weakSelf.timer?.invalidate()
                weakSelf.timer = nil
            }
            count -= 1
            weakSelf.codeBtn.setTitle("重新获取(\(count))", for: .disabled)
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    override func changeTel(tf: UITextField) {
        codeBtn.isEnabled = tf.text?.count == 11
        if tf.text?.count == 11 && codeField.text?.count == 6 {
            submmitBtn.isEnabled = true
        }else{
            submmitBtn.isEnabled = false
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    override func changeCode(tf: UITextField) {
        if tf.text?.count == 6 && phoneField.text?.count == 11 {
            submmitBtn.isEnabled = true
        }else{
            submmitBtn.isEnabled = false
        }
    }
    
    deinit {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}
