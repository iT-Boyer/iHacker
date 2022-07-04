//
//  CheckEditBaseCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/1.
//

import UIKit

enum CheckEditCellType {
    case note       //备注
    case sign       //签字
}

struct CheckEditCellVM {
    var desc:String?
    var type:CheckEditCellType = .note
    var note = "", picture:String? = ""
}

class CheckEditBaseCell: UITableViewCell {

    var actionHandler:(CheckEditCellVM?)->Void = {_ in}
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        createView()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var model:CheckEditCellVM?{
        willSet{
            guard let new = newValue else { return }
            descLab.text = new.desc
        }
    }
    
    func updateUI() {}
    
    func createView() {
        contentView.addSubviews([iconView, descLab, actionView])
        iconView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        descLab.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.centerY.equalTo(iconView.snp.centerY)
        }
        actionView.snp.makeConstraints { make in
            make.leading.equalTo(descLab.snp.leading)
            make.height.equalTo(74)
            make.top.equalTo(descLab.snp.bottom).offset(8)
            make.right.equalTo(-20)
            make.bottom.equalTo(-10)
        }
    }
    
    lazy var iconView = UIImageView()
    lazy var descLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 15)
        return lab
    }()
    
    lazy var actionView: UIView = {
        let action = UIView()
        return action
    }()
    
}
