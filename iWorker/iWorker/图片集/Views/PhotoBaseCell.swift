//
//  PhotoBaseCell.swift
//  iWorker
//
//  Created by boyer on 2022/6/8.
//

import UIKit
import JHBase

class PhotoBaseCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createView() {
        contentView.addSubviews([iconView,titleLab])
        iconView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 130, height: 115))
            make.top.equalTo(15)
            make.bottom.equalToSuperview()
            make.left.equalTo(12)
        }
        titleLab.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.left.equalTo(iconView.snp.right).offset(8)
            make.top.equalTo(iconView.snp.top).offset(16)
            make.bottom.lessThanOrEqualTo(iconView.snp.bottom).offset(-10)
        }
    }
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 8
        icon.layer.masksToBounds = true
        icon.image = .init(named: "videoplaceholdersmall")
        return icon
    }()
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.font = .systemFont(ofSize: 16)
        lab.textColor = .k2F3856
        return lab
    }()
}
