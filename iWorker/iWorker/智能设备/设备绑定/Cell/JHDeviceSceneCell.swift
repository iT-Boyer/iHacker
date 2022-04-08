//
//  JHDeviceSceneCell.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//

import UIKit
// 迁移JHBindingDeviceNameSelectCell.m
class JHDeviceSceneCell:JHDeviceBaseCell{//: VBindable<JHSceneViewModel> {

    override func createView() {
        super.createView()
        titleLab.text = "设备场景类型"
        layoutView(first: titleLab, second: sceneField)
    }
    
    func bind(viewModel vm:JHSceneViewModel){
        if kvoToken == nil {
            kvoToken = vm.observe(\.sceneName, options: [.new, .old]) { (model, change) in
                guard let name = change.newValue else { return }
                self.sceneField.text = name
                print("设备场景: \(name ?? "")")
            }
        }
    }
    
    lazy var sceneField: UITextField = {
        let field = UITextField()
        field.isUserInteractionEnabled = false
        field.font = .systemFont(ofSize: 14)
        field.textColor = .initWithHex("5E637B")
        let arr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                   .foregroundColor: UIColor(hexString: "B5B5B5")!]
        field.attributedPlaceholder = NSAttributedString(string: "请选择设备场景类型", attributes: arr)
        return field
    }()
}
