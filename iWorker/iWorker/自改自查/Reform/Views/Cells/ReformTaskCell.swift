//
//  ReformTaskCell.swift
//  iWorker
//
//  Created by boyer on 2022/7/20.
//

import UIKit
import JHBase

class ReformTaskCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var model:ReformTaskModel?{
        willSet{
            guard let new = newValue else { return }
            titleLab.text = new.classificationName
            if new.isCompleted ?? false {
                statusLab.text = "已完成"
                statusLab.textColor = .k666666
            }else{
                statusLab.text = "未完成"
                statusLab.textColor = .kFF6A34
            }
        }
    }
    
    func createView() {
        //TODO: 自定义视图
        contentView.addSubviews([titleLab, statusLab])
        titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(25)
        }
        
        statusLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .k2F3856
        lab.font = .systemFont(ofSize: 15)
        return lab
    }()
    
    lazy var statusLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .k666666
        lab.font = .systemFont(ofSize: 12)
        return lab
    }()
}
