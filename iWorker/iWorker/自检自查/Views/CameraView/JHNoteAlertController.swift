//
//  JHNoteAlertController.swift
//  iWorker
//
//  Created by boyer on 2022/7/6.
//

import UIKit
import JHBase

class JHNoteAlertController: UIViewController {

    var note:String = "请输入..."
    var noteHandler:(String)->Void = {_ in}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createView()
        textView.text = note
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //屏蔽转场遮罩点击事件
        view.frame.size = CGSize(width: kScreenWidth, height: kScreenHeight)
        view.frame.origin = .zero
    }
    
    func createView() {
        
        bodyView.addSubviews([titleLab, textView, numberLab, saveBtn])
        
        view.addSubviews([bodyView, closeBtn])
        
        bodyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(kScreenWidth - 40)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(bodyView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.height.equalTo(128)
            make.centerX.equalToSuperview()
        }
        
        numberLab.snp.makeConstraints { make in
            make.bottom.equalTo(textView.snp.bottom)
            make.right.equalTo(textView.snp.right).offset(-5)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(40)
            make.left.equalTo(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(-15)
        }
    }
    
    lazy var bodyView: UIView = {
        let body = UIView()
        body.layer.cornerRadius = 10
        body.backgroundColor = .white
        return body
    }()
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.text = "录入整改措施落实情况"
        lab.font = .systemFont(ofSize: 17)
        return lab
    }()
    
    lazy var textView: UITextView = {
        let text = UITextView()
        text.delegate = self
        text.backgroundColor = .kF8F8F8
        text.textColor = .k5E637B
        text.font = .systemFont(ofSize: 15)
        return text
    }()
    
    lazy var numberLab: UILabel = {
        let lab = UILabel()
        lab.text = "0/40"
        lab.textColor = .k999999 // 99a0b6
        lab.font = .systemFont(ofSize: 12)
        return lab
    }()
    
    lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .initWithHex("FDAD44")
        btn.layer.cornerRadius = 10
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self, let tex = wf.textView.text, !tex.isEmpty else {return}
            wf.noteHandler(tex)
            wf.dismiss(animated: true)
        }
        return btn
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "Inspect关闭"), for: .normal)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self else {return}
            wf.dismiss(animated: true)
        }
        return btn
    }()
}

extension JHNoteAlertController:UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "请输入..." {
            textView.textColor = .k2F3856
            textView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.isEmpty{
            textView.textColor = .k2F3856
            noteHandler(textView.text)
        }else{
            textView.textColor = .k99A0B6
            textView.text = "请输入..."
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 40 {
            textView.text = String(textView.text[0..<40])
            return
        }
        if textView.text != "请输入..." {
            numberLab.text = "\(textView.text.count)/40"
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
