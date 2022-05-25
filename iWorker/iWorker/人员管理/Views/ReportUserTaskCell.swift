//
//  ReportUserTaskCell.swift
//  iWorker
//
//  Created by boyer on 2022/5/25.
//

import Foundation
import UIKit
import JHBase

class ReportUserTaskCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let nameLab = UILabel()
    let statusLab = UILabel()
    let timeLab = UILabel()
    let lastDateLab = UILabel()
    
    var model:ReportMapUserTaskM!{
        didSet{
            nameLab.text = model.taskName
            timeLab.text = "任务时间：\(model.subTime)"
            lastDateLab.text = "任务期限：\(model.startTime)-\(model.endTime)"
            var text = "  待检查  "
            var color = "2CD773"
            if model.taskStatus == 3 {
                text = "  超期未查  "
                color = "FF6A34"
            }
            statusLab.text = text
            statusLab.layer.borderColor = UIColor.initWithHex(color).cgColor
        }
    }
    
    func createView() {
        
        nameLab.font = .systemFont(ofSize: 14)
        nameLab.textColor = .initWithHex("2F3856")
        
        statusLab.font = .systemFont(ofSize: 12)
        statusLab.textColor = .initWithHex("FF6A34")
        statusLab.layer.cornerRadius = 4
        statusLab.layer.borderWidth = 1
        
        timeLab.isHidden = true
        timeLab.font = .systemFont(ofSize: 12)
        timeLab.textColor = .initWithHex("99A0B6")
        
        lastDateLab.font = .systemFont(ofSize: 12)
        lastDateLab.textColor = .initWithHex("99A0B6")
        
        contentView.addSubviews([nameLab,statusLab,timeLab,lastDateLab])
        
        nameLab.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(12)
        }
        
        statusLab.snp.makeConstraints { make in
            make.centerY.equalTo(nameLab.snp.centerY)
            make.height.equalTo(18)
            make.left.equalTo(nameLab.snp.right).offset(8)
        }
        timeLab.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(nameLab.snp.bottom).offset(8)
        }
        lastDateLab.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(nameLab.snp.bottom).offset(8)
            make.bottom.equalTo(-15)
        }
    }
}
