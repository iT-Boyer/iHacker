//
//  LoginGetBackPassword.swift
//  iWorker
//
//  Created by boyer on 2022/5/11.
//

import UIKit
import JHBase

class LoginGetBackPassword: JHBaseNavVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navTitle = "找回交易密码"
        createView()
    }

    func createView() {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 6
        textView.isEditable = false
        textView.isScrollEnabled = false
//        textView.contentInset = .init(top: 15, left: 12, bottom: 15, right: 12)
        textView.textContainerInset = .init(top: 15, left: 12, bottom: 15, right: 12)
        
        let text = "您还没有设置过交易密保问题，或忘记密保答案，请联系我们的客服，申请重置交易密码。\n客服将在48小时处理。\n联系电话：010-58858686-8052"
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 5 // 字体的行间距
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),
                          NSAttributedString.Key.foregroundColor:UIColor.initWithHex("5E637B"),
                          NSAttributedString.Key.paragraphStyle: paraph]
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(8)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
    }
}
