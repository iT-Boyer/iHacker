//
//  JHDeviceSNCell.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//

import UIKit
import SnapKit

// 迁移JHBindingDeviceNameInputImageCell.m
class JHDeviceSNCell: JHDeviceBaseCell {
    
    override func createView() {
        super.createView()
        titleLab.text = "设备SN号"
        layoutView(first: titleLab, second: snField, third: scanBtn)
    }
    lazy var snField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 14)
        field.textColor = .initWithHex("5E637B")
        field.returnKeyType = .done
        field.keyboardType = .asciiCapable
        field.clearButtonMode = .whileEditing
        let arr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                   .foregroundColor: UIColor(hexString: "ADADAD")!]
        field.attributedPlaceholder = NSAttributedString(string: "请输入设备SN号", attributes: arr)
        return field
    }()
    
    lazy var scanBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "scanDevice"), for:.normal)
        btn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 22, height: 22))
        }
        return btn
    }()
    
}
