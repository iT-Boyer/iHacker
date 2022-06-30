//
//  JHInspectBaseCell.swift
//  iWorker
//
//  Created by boyer on 2022/6/29.
//

import UIKit
import JHBase

class JHInspectBaseCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var model:InspectOptionModel?{
        didSet{
            guard let mm = model else { return }
            noteLab.text = mm.text
        }
    }
    
    
    func createView() {
        contentView.addSubviews([cameraBtn, noteLab, arrowIcon, stackView])
        
        cameraBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.top.equalTo(15)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        noteLab.snp.makeConstraints { make in
            make.left.equalTo(cameraBtn.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        arrowIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(noteLab.snp.right).offset(8)
            make.size.equalTo(CGSize(width: 11, height: 20))
        }
        stackView.snp.makeConstraints { make in
            make.left.equalTo(arrowIcon.snp.right).offset(8)
            make.width.equalTo(65 + 10)
            make.height.equalTo(33)
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
        
        let numView = UIImageView(image: .init(named: "Inspect照片数量"))
        cameraBtn.addSubview(numView)
        numView.addSubview(numLab)
        numView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 26, height: 14))
            make.bottom.right.equalToSuperview()
        }
        numLab.snp.makeConstraints { make in
            make.centerX.equalTo(3)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var stackView: UIStackView = {
        let arrView = [vline, switchBtn]
        let stack = UIStackView(arrangedSubviews: arrView, axis: .horizontal)
        stack.spacing = 5
        stack.distribution = .fillProportionally
        return stack
    }()
    
    lazy var cameraBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "Inspectcamera"), for: .normal)
        btn.jh.setHandleClick {[weak self] button in
            //TODO: 拍照
            guard let wf = self else { return }
            
        }
        return btn
    }()
    
    lazy var numLab: UILabel = {
        let num = UILabel()
        num.textColor = .white
        num.font = .systemFont(ofSize: 9)
        return num
    }()
    
    lazy var noteLab: UILabel = {
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
    
    lazy var switchBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.init(named: "Inspectpshi"), for: .normal)
        btn.setImage(.init(named: "Inspectfou"), for: .selected)
        btn.jh.setHandleClick {[weak self] button in
            guard let wf = self, let btn = button else {return}
            wf.switchBtn.isSelected = !btn.isSelected
        }
        return btn
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
