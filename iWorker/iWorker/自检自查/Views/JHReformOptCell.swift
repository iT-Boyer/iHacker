//
//  JHReformOptCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/1.
//

import Foundation
import JHBase
import UIKit

class JHReformOptCell: JHInspectBaseCell {
    
    override func createView() {
        super.createView()
        stackView.addArrangedSubview(signBtn)
        
        contentView.addSubview(noteLab)
        titleLab.snp.remakeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(cameraBtn.snp.right).offset(8)
            make.right.equalTo(arrowIcon.snp.left).offset(-8)
        }
        noteLab.snp.makeConstraints { make in
            make.leading.equalTo(titleLab.snp.leading)
            make.trailing.equalTo(titleLab.snp.trailing)
            make.top.equalTo(titleLab.snp.bottom).offset(5)
            make.bottom.equalTo(-5)
        }
    }
    var model:ReformOptionModel?{
        willSet{
            guard let new = newValue else { return }
            titleLab.text = new.remark
        }
    }
    lazy var signBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("负责人签字", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 60))
        }
        btn.addTarget(self, action: #selector(signAction), for: .touchDown)
        return btn
    }()
    
    @objc func signAction() {
        //TODO: 签名跳转
        let signvc = InsSignViewController()
        signvc.signHandler = { url in
//            model?.picture = url
//            actionHandler(wf.model)
        }
        UIViewController.topVC?.present(signvc, animated: true)
    }
    
    @objc func noteAction() {
        //TODO: 弹出编辑框
        
    }
    
    lazy var noteLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .initWithHex("FF4835")
        lab.font = .systemFont(ofSize: 12)
        lab.numberOfLines = 0
        lab.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(noteAction))
        lab.addGestureRecognizer(tap)
        return lab
    }()
}
