//
//  JHNewLoginSetPswViewController.swift
//  iWorker
//
//  Created by boyer on 2022/5/11.
//

import UIKit
import JHBase

class JHNewLoginSetPswViewController: JHBaseNavVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navTitle = "设置密码"
        createView()
    }
    
    func createView() {
        view.backgroundColor = .white
        let tipLab = UILabel()
        
        tipLab.font = .systemFont(ofSize: 13)
        tipLab.textColor = .initWithHex("04A174")
        tipLab.textAlignment = .center
        tipLab.backgroundColor = .initWithHex("EEF7F4")
        tipLab.text = "设置密码后，你可以用手机号和密码登录"
        view.addSubview(tipLab)
        
        let newPwd = UILabel()
        let tryPwd = UILabel()
        newPwd.text = "设置密码"
        newPwd.textColor = .initWithHex("2F3856")
        newPwd.font = .systemFont(ofSize: 14)
        tryPwd.text = "设置密码"
        tryPwd.textColor = .initWithHex("2F3856")
        tryPwd.font = .systemFont(ofSize: 14)
        
        let line = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
        line.backgroundColor = .initWithHex("EEEEEE")
        
        view.addSubviews([newPwd,newPwdField,seeNewPwdBtn,line,tryPwd,tryPwdField,seeTryPwdBtn,submmitBtn])
        
        tipLab.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(35)
        }
        newPwd.snp.makeConstraints { make in
            make.top.equalTo(tipLab.snp.bottom).offset(20)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        newPwdField.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(newPwd.snp.bottom).offset(15)
        }
        seeNewPwdBtn.snp.makeConstraints { make in
            make.centerY.equalTo(newPwdField)
            make.left.equalTo(newPwdField.snp.right)
            make.right.equalTo(-12)
        }
        line.snp.makeConstraints { make in
            make.top.equalTo(newPwdField.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.height.equalTo(0.5)
            make.right.equalToSuperview()
        }
        tryPwd.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        tryPwdField.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(tryPwd.snp.bottom).offset(15)
        }
        seeTryPwdBtn.snp.makeConstraints { make in
            make.centerY.equalTo(tryPwdField)
            make.width.equalTo(seeNewPwdBtn)
            make.left.equalTo(tryPwdField.snp.right)
            make.right.equalTo(-12)
        }
        submmitBtn.snp.makeConstraints { make in
            make.top.equalTo(tryPwdField.snp.bottom).offset(50)
            make.left.equalTo(12)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var newPwdField: UITextField = {
        let tf = UITextField()
        tf.textColor = .initWithHex("2F3856")
        tf.isSecureTextEntry = true
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor:UIColor.initWithHex("B5B5B5")]
        tf.attributedPlaceholder = NSAttributedString(string: "请输入6-16位数字或字母，区分大小写", attributes: attributes)
        return tf
    }()
    lazy var seeNewPwdBtn: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(.init(named: "noseepwd"), for: .normal)
        btn.setImage(.init(named: "seepwd"), for: .selected)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 4, left: 88, bottom: 4, right: 0)
        
        btn.jh.setHandleClick {[unowned self] button in
            guard let but = button else{return}
            but.isSelected = !but.isSelected
            newPwdField.isSecureTextEntry = !but.isSelected
        }
        return btn
    }()
    lazy var tryPwdField: UITextField = {
        let tf = UITextField()
        tf.textColor = .initWithHex("2F3856")
        tf.isSecureTextEntry = true
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.foregroundColor:UIColor.initWithHex("B5B5B5")]
        tf.attributedPlaceholder = NSAttributedString(string: "请再次输入上面的密码", attributes: attributes)
        return tf
    }()
    lazy var seeTryPwdBtn: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(.init(named: "noseepwd"), for: .normal)
        btn.setImage(.init(named: "seepwd"), for: .selected)
        btn.jh.setHandleClick {[unowned self] button in
            guard let but = button else{return}
            but.isSelected = !but.isSelected
            tryPwdField.isSecureTextEntry = !but.isSelected
        }
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 4, left: 88, bottom: 4, right: 0)
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

extension JHNewLoginSetPswViewController
{
    @objc func submmit() {
        
    }
    @objc func newpwd(tf:UITextField) {
        let rules = NSPredicate(format: "SELF MATCHES %@", "^[0-9A-Za-z]{6,16}$")
        let isNumber: Bool = rules.evaluate(with: tf.text)
        
    }
    
    @objc func trypwd(tf:UITextField) {
        let rules = NSPredicate(format: "SELF MATCHES %@", "^[0-9A-Za-z]{6,16}$")
        let isNumber: Bool = rules.evaluate(with: tf.text)
    }
}
