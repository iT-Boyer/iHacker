//
//  JHSwitchView.swift
//  iWorker
//
//  Created by boyer on 2022/6/29.
//

import Foundation
import UIKit

class JHSwitchView: UISwitch {
    
    init() {
        super.init(frame: .zero)
        addSubviews([leftLab,rightLab])
        leftLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(10)
        }
        
        rightLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalTo(-25)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
