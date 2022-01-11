//
//  JHUnitOrgSearchCell.swift
//  iWorker
//
//  Created by boyer on 2022/1/10.
//

import UIKit

class JHUnitOrgSearchCell: JHUnitOrgBaseCell {

    var selectBtn:UIButton!
    
    override func createView() {
        super.createView()
        selectBtn = UIButton()
        selectBtn.setImage(.init(named: "unitorgselect"), for: .normal)
        selectBtn.setImage(.init(named: "unitorgselected"), for: .selected)
        contentView.addSubview(selectBtn)
        selectBtn.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 18, bottom: 10, right: 18)
        selectBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(name.snp.centerY)
            make.size.equalTo(CGSize(width: 22+36, height: 22+20))
        }
        name.snp.updateConstraints { make in
            make.right.equalTo(-22-10-8)
        }
    }
}
