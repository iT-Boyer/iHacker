//
//  JHDeviceSNCell.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//

import UIKit
import SnapKit

// 迁移JHBindingDeviceNameInputImageCell.m
class JHDeviceSNCell: JHDeviceBaseCell,UITextFieldDelegate {//: VBindable<JHSNViewModel>,UITextFieldDelegate {
    
    @objc dynamic var SNCode:String?
    
    override func createView() {
        super.createView()
        titleLab.text = "设备SN号"
        layoutView(first: titleLab, second: snField, third: scanBtn)
    }
    private lazy var snField: UITextField = {
        let field = UITextField()
        field.delegate = self
        field.font = .systemFont(ofSize: 14)
        field.textColor = .initWithHex("5E637B")
        field.returnKeyType = .done
        field.keyboardType = .asciiCapable
        field.clearButtonMode = .whileEditing
        field.addTarget(self, action: #selector(textFieldDidChangeValue(textField:)), for: .editingChanged)
        let arr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                   .foregroundColor: UIColor(hexString: "ADADAD")!]
        field.attributedPlaceholder = NSAttributedString(string: "请输入设备SN号", attributes: arr)
        return field
    }()
   
    @objc
    func textFieldDidChangeValue(textField:UITextField) {
        self.SNCode = textField.text
    }
    lazy var scanBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "scanDevice"), for:.normal)
        btn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 22, height: 22))
        }
        btn.addTarget(self, action: #selector(scanAction), for: .touchDown)
        return btn
    }()
    
    func bind(viewModel vm:JHSNViewModel){
        if kvoToken == nil {
            kvoToken = vm.observe(\.value, options: [.new, .old]) { (model, sn) in
                let new = sn.newValue ?? ""
                print("扫一扫SN：\(new ?? "")")
                self.snField.text = new
                self.SNCode = new
            }
        }
    }
    
    // MARK: - 扫一扫
    @objc func scanAction() {
        //TODO: 集成扫一扫
        let scan = "scancode"
        NotificationCenter.default.post(name: .init("JHDeviceScanSNCompleted"), object: nil, userInfo: ["SNCode":scan])
    }
    
}
