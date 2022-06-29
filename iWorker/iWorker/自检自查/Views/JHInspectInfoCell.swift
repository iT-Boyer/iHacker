//
//  CheckerBaseCell.swift
//  iWorker
//
//  Created by boyer on 2022/6/27.
//

import UIKit

class JHInspectInfoCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
//        backgroundColor = .clear
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var model:CheckerBaseVM?{
        didSet{
            guard let mm = model else {return}
            iconView.image = .init(named: mm.icon ?? "")
            nameLab.text = mm.name ?? ""
            valueLab.text = mm.value ?? ""
        }
    }
    
    func createView() {
        contentView.backgroundColor = .clear
        contentView.addSubviews([iconView, nameLab,valueLab])
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 13))
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        nameLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconView.snp.right).offset(10)
        }
        
        valueLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
        }
    }
    
    lazy var iconView: UIImageView = {
        let imgview = UIImageView()
        return imgview
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .k000000
        lab.font = .systemFont(ofSize: 15)
        return lab
    }()
    
    lazy var valueLab: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .right
        lab.font = .systemFont(ofSize: 15)
        return lab
    }()
}
