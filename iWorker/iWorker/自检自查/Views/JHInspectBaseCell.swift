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
        contentView.addSubviews([cameraBtn, noteLab, stackView])
        
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
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(noteLab.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
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
        let arrView = [arrowIcon, vline, switchBtn]
        let stack = UIStackView(arrangedSubviews: arrView, axis: .horizontal)
        stack.spacing = 10
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
        note.text = ""
        note.textColor = .k333333
        note.font = .systemFont(ofSize: 15)
        return note
    }()
    
    lazy var arrowIcon: UIImageView = {
        let arrow = UIImageView(image: .init(named: "Inspect灰箭头"))
        arrow.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 11, height: 20))
        }
        return arrow
    }()
    
    lazy var vline: UIView = {
        let line = UIView()
        line.backgroundColor = .initWithHex("A9A9A9")
        line.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.height.equalTo(30)
        }
        return line
    }()
    
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
}
