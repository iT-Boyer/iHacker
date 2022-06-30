//
//  JHOptionsHeaderView.swift
//  iWorker
//
//  Created by boyer on 2022/6/30.
//

import UIKit

class JHOptionsHeaderView: UIView {

    //type 第一步，第二步，第三步
    init(name:String = "", note:String = "") {
        super.init(frame: .zero)
        let icon = UIImageView(image: .init(named: "Inspect检查项"))
        let title = UILabel()
        title.text = name
        title.textColor = .k333333
        title.font = .systemFont(ofSize: 15)
        
        let noteLab = UILabel()
        noteLab.text = note
        noteLab.textColor = .k333333
        noteLab.font = .systemFont(ofSize: 15)
        
        let line = UIView()
        line.backgroundColor = .initWithHex("A9A9A9")
        addSubviews([icon, title, line, noteLab])
        icon.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.size.equalTo(CGSize(width: 22, height: 22))
            make.left.equalTo(15)
            make.bottom.equalTo(-10)
        }
        title.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(8)
            make.centerY.equalTo(icon.snp.centerY)
        }
        
        noteLab.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalTo(title.snp.centerY)
        }
        
        line.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.right.left.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
