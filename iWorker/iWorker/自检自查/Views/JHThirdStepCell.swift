//
//  JHThirdStepCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/1.
//

import Foundation
import JHBase
import UIKit

class JHThirdStepCell: JHInspectBaseCell {
    
    override func createView() {
        super.createView()
        stackView.addArrangedSubview(checkBtn)
    }
    
    var model:AddInsOptModel?{
        didSet{
            guard let mm = model else { return }
            titleLab.text = mm.origin?.text
            cameraBtn.isHidden = mm.origin?.isNeedPic ?? false
            checkBtn.isSelected = mm.status == 1
            let imageName = checkBtn.isSelected ? "Inspect第三步状态":"Inspect第三步状态2"
            checkBtn.setBackgroundImage(.init(named:imageName), for: .normal)
        }
    }
    
    lazy var checkBtn: UIButton = {
        let check = UIButton()
        check.isUserInteractionEnabled = false
        check.titleLabel?.font = .systemFont(ofSize: 15)
        check.setTitle("否", for: .normal)
        check.setTitleColor(.k999999, for: .normal)
        check.setTitle("是", for: .selected)
        check.setTitleColor(.white, for: .selected)
        check.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 65, height: 33))
        }
        return check
    }()
    
}
