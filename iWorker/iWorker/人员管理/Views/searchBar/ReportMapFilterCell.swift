//
//  ReportMapFilterCell.swift
//  iWorker
//
//  Created by boyer on 2022/5/25.
//

import Foundation
import UIKit
import JHBase

class ReportMapFilterCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var model:ReportLastFootM!{
        didSet{
            nameLab.text = model.userName
            codeLab.text = "ID：\(model.userTel)"
            iconView.kf.setImage(with: URL(string: model.userHeadIcon), placeholder: UIImage(named: "vatoricon"))
        }
    }
    
    func createView() {
        contentView.addSubviews([nameLab,codeLab,iconView])
        iconView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.top.equalTo(14)
            make.bottom.equalTo(-14)
            make.left.equalTo(8)
        }
        
        nameLab.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(8)
            make.top.equalTo(iconView.snp.top).offset(3)
        }
        
        codeLab.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(8)
            make.bottom.equalTo(iconView.snp.bottom)
        }
    }
    
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 15)
        lab.textColor = .initWithHex("2F3856")
        return lab
    }()
    lazy var codeLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .initWithHex("99A0B6")
        return lab
    }()
    lazy var iconView: UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 18
        icon.layer.masksToBounds = true
        return icon
    }()
}
