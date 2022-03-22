//
//  JHDeviceSceneCell.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//

import UIKit
// 迁移JHBindingDeviceNameSelectCell.m
class JHDeviceSceneCell: JHDeviceBaseCell {

    var kvoToken: NSKeyValueObservation?
    override func createView() {
        super.createView()
        titleLab.text = "设备场景类型"
        layoutView(first: titleLab, second: sceneBtn)
    }
    
    func bind(_ vm:JHSceneViewModel) {
        if kvoToken == nil {
            kvoToken = vm.observe(\.sceneName, options: [.new, .old]) { (scene, change) in
                guard let name = change.newValue else { return }
                self.sceneBtn.setTitle(name, for: .selected)
                self.sceneBtn.isSelected = true
                print("设备场景: \(name ?? "")")
            }
        }
    }
    
    lazy var sceneBtn: UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        btn.setTitleColor(.initWithHex("B5B5B5"), for: .normal)
        btn.setTitleColor(.initWithHex("5E637B"), for: .selected)
        btn.setTitle("请选择设备场景类型", for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        return btn
    }()
    
    
    deinit {
        kvoToken?.invalidate()
    }
}
