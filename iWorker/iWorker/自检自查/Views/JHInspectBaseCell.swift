//
//  JHInspectBaseCell.swift
//  iWorker
//
//  Created by boyer on 2022/6/29.
//

import UIKit
import JHBase

class JHInspectBaseCell: UITableViewCell {

    var actionHandler:(AddInsOptModel?)->Void = {_ in}
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createView() {
        contentView.addSubviews([cameraBtn, titleLab, arrowIcon, stackView])
        
        cameraBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.top.equalTo(15)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(cameraBtn.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        arrowIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLab.snp.right).offset(8)
            make.size.equalTo(CGSize(width: 11, height: 20))
        }
        stackView.snp.makeConstraints { make in
            make.left.equalTo(arrowIcon.snp.right).offset(8)
//            make.width.greaterThanOrEqualTo(65 + 10)
//            make.height.greaterThanOrEqualTo(33)
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
        cameraBtn.addSubview(numView)
        numView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 26, height: 14))
            make.bottom.right.equalToSuperview()
        }
    }
    
    lazy var stackView: UIStackView = {
        let arrView = [vline]
        let stack = UIStackView(arrangedSubviews: arrView, axis: .horizontal)
        stack.spacing = 5
        stack.distribution = .fillProportionally
        return stack
    }()
    
    lazy var cameraBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var numView: UIImageView = {
        let num = UIImageView(image: .init(named: "Inspect照片数量"))
        num.addSubview(numLab)
        numLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-2)
            make.left.equalTo(8)
        }
        return num
    }()
    
    lazy var numLab: UILabel = {
        let num = UILabel()
        num.textColor = .white
        num.textAlignment = .center
        num.font = .systemFont(ofSize: 9)
        return num
    }()
    
    lazy var titleLab: UILabel = {
        let note = UILabel()
        note.textColor = .k333333
        note.font = .systemFont(ofSize: 15)
        return note
    }()
    
    lazy var arrowIcon: UIImageView = {
        let arrow = UIImageView(image: .init(named: "Inspect灰箭头"))
        return arrow
    }()
    
    lazy var vline: UIView = {
        let line = UIView()
        line.backgroundColor = .initWithHex("A9A9A9")
        line.snp.makeConstraints { make in
            make.width.equalTo(0.5)
        }
        return line
    }()
    
    lazy var switchBtn1: JHSwitchView = {
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
}
