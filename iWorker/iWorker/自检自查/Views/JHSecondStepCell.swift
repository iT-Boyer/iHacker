//
//  JHSecondStepCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/1.
//

import Foundation
import UIKit
import TZImagePickerController

class JHSecondStepCell: JHInspectBaseCell {
    
    let vctools = VCTools()
    override func createView() {
        super.createView()
        stackView.addArrangedSubviews([pullBtn,switchBtn])
        
        cameraBtn.jh.setHandleClick {[weak self] button in
            //TODO: 拍照
            guard let wf = self else { return }
            guard let pics = wf.model?.pictures else {
                //TODO: 拍照
                wf.vctools.showCamera(count: 1) {[weak self] model in
                    guard let wf = self else { return }
                    wf.model?.picture = model.url
                    wf.actionHandler(wf.model)
                }
                return
            }
            let alert = JHCameraAlertController()
            alert.transitioningDelegate = wf.transitionDelegate
            alert.modalPresentationStyle = .custom
            alert.originArray = pics
            alert.cameraHandler = {[weak self] item in
                guard let wf = self else { return }
                wf.model?.picture = item.url
                wf.actionHandler(wf.model)
            }
            UIViewController.topVC?.present(alert, animated: true)
        }
    }
    
    lazy var transitionDelegate: JHCameraTransitionDelegate = {
        let delegate = JHCameraTransitionDelegate()
        return delegate
    }()
    
    var model:AddInsOptModel?{
        willSet{
            guard let mm = newValue else { return }
            
            titleLab.text = mm.origin?.text
            cameraBtn.isHidden = !(mm.origin?.isNeedPic ?? false)
            if let pics = mm.pictures, let first = pics.first {
                numView.isHidden = false
                numLab.text = "\(pics.count)"
                cameraBtn.kf.setImage(with: URL(string: first.url), for: .normal, placeholder: UIImage(named: "Inspectcamera"))
            }else{
                numView.isHidden = true
                cameraBtn.setImage(UIImage(named: "Inspectcamera"), for: .normal)
            }
            
            let isOption = mm.origin?.isNotForAll ?? false
            switchBtn.isHidden = isOption
            pullBtn.isHidden = !isOption
            
            if isOption {
                if mm.status == 0 {
                    pullBtn.setTitle("   否   ", for: .normal)
                    pullBtn.titleLabel?.font = .systemFont(ofSize: 14)
                }else
                if mm.status == 1 {
                    pullBtn.setTitle("   是   ", for: .normal)
                    pullBtn.titleLabel?.font = .systemFont(ofSize: 14)
                }else
                if mm.status == 2 {
                    pullBtn.setTitle("合理缺项", for: .normal)
                    pullBtn.titleLabel?.font = .systemFont(ofSize: 12)
                }
            }else{
                switchBtn.isSelected = mm.status == 1
            }
        }
    }
    
    lazy var switchBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "Inspectpshi"), for: .normal)
        btn.setImage(.init(named: "Inspectfou"), for: .selected)
        btn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 65, height: 33))
        }
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self, let btn = button else {return}
            btn.isSelected = !btn.isSelected
            guard var item = wf.model else { return }
            item.status = btn.isSelected ? 1:0
            wf.actionHandler(item)
        }
        return btn
    }()
    
    lazy var pullBtn: UIButton = {
        let pull = UIButton()
        pull.titleLabel?.font = .systemFont(ofSize: 14)
        pull.setTitle("   是   ", for: .normal)
        pull.setTitleColor(.black, for: .normal)
        pull.setImage(.init(named: "Inspectxiala"), for: .normal)
//        pull.setImage(.init(named: "pshi"), for: .selected)
        pull.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 65, height: 33))
        }
        pull.addTarget(self, action: #selector(showAlertView), for: .touchDown)
        return pull
    }()
    
    @objc func showAlertView() {
        let btns:[String] = ["是", "否", "合理缺项", "取消"]
        let types:[UIAlertAction.Style] = [.default, .default, .default, .cancel]
        UIAlertController.showDarkSheet(btns: btns, types: types) {[weak self] row in
            //TODO: 选择自检类型
            guard let wf = self else { return }
            if row == btns.count - 1 { return } //取消按钮
            guard var item = wf.model else { return }
            if row == 0 { item.status = 1 }
            if row == 1 { item.status = 0 }
            if row == 2 { item.status = 2 }
            wf.actionHandler(item)
        }
    }
}
