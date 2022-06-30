//
//  JHSwitchView.swift
//  iWorker
//
//  Created by boyer on 2022/6/29.
//

import Foundation
import UIKit

/**
 1. 无法使用willSet监听isOn属性, 仅对UISwitch 无效
 2. 无法设置UISwitch大小
    btn.transform = CGAffineTransform(scaleX: 1.2, y: 1.15)
 
 // 使用案例
 lazy var switchBtn: JHSwitchView = {
     let btn = JHSwitchView()
     btn.isOn = false
     btn.addTarget(self, action: #selector(switchAction(btn:)), for: .valueChanged)
     btn.snp.makeConstraints { make in
         make.size.equalTo(CGSize(width: 65, height: 30))
     }
     btn.transform = CGAffineTransform(scaleX: 1.2, y: 1.15)
     return btn
 }()
 
 @objc func switchAction(btn:JHSwitchView) {
     print("开关状态：\(btn.isOn)")
     btn.leftLab.isHidden = !btn.isOn
     btn.rightLab.isHidden = btn.isOn
 }
 */
class JHSwitchView: UISwitch {
    
    init() {
        super.init(frame: .zero)
        addSubviews([leftLab,rightLab])
        leftLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(7)
        }
        
        rightLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalTo(-23)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //UISwitch 属性监听无效
    override var isOn: Bool{
        didSet{
            print("子类：isOn didSet")
            leftLab.isHidden = !oldValue
            rightLab.isHidden = oldValue
        }
        
        willSet{
            print("子类：isOn didSet")
            leftLab.isHidden = !newValue
            rightLab.isHidden = newValue
        }

    }
    
    lazy var leftLab: UILabel = {
        let lab = UILabel()
        lab.text = "是"
        lab.textColor = .darkGray
        lab.font = .systemFont(ofSize: 10)
        return lab
    }()
    
    lazy var rightLab: UILabel = {
        let lab = UILabel()
        lab.text = "否"
        lab.textColor = .red
        lab.font = .systemFont(ofSize: 10)
        return lab
    }()
}
