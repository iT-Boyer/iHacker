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
    
    var reformHandler:(ReformOptionModel)->Void = {_ in}
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
    
    
    @objc func showNoteAlert() {
        //TODO: 浮动编辑框
        let alert = JHNoteAlertController()
        alert.transitioningDelegate = transitionDelegate
        alert.modalPresentationStyle = .custom
        alert.note = model?.remark
        alert.noteHandler = {[weak self] text in
            guard let wf = self,var mm = wf.model else { return }
            mm.remark = text
            wf.reformHandler(mm)
        }
        UIViewController.topVC?.present(alert, animated: true)
    }
    
    var model:ReformOptionModel?{
        willSet{
            guard let new = newValue else { return }
            titleLab.text = new.text
            noteLab.text = new.remark
            if let url = new.signature {
                signBtn.setTitle(nil, for: .normal)
                signBtn.kf.setImage(with: URL(string: url), for: .normal)
            }else{
                signBtn.setTitle("负责人签字", for: .normal)
            }
            
            if let pics = new.pictures, let first = pics.first {
                optionPics = pics
                numView.isHidden = false
                numLab.text = "\(pics.count)"
                cameraBtn.kf.setImage(with: URL(string: first.url), for: .normal, placeholder: UIImage(named: "Inspectcamera"))
            }else{
                numView.isHidden = true
                cameraBtn.setImage(UIImage(named: "Inspectcamera"), for: .normal)
            }
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
        signvc.signHandler = {[weak self] url in
            guard let wf = self, var mm = wf.model else { return }
            mm.signature = url
            wf.reformHandler(mm)
        }
        signvc.modalPresentationStyle = .fullScreen
        UIViewController.topVC?.present(signvc, animated: true)
    }
    
    lazy var noteLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .initWithHex("FF4835")
        lab.font = .systemFont(ofSize: 12)
        lab.numberOfLines = 0
        lab.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showNoteAlert))
        lab.addGestureRecognizer(tap)
        return lab
    }()
}
