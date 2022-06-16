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
        super.init(coder: coder)
    }
    
    var model:ReportMapUserTaskM?{
        didSet{
            guard let mm = model else { return }
            nameLab.text = mm.taskName
            timeLab.text = "任务时间：\(mm.subTime)"
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let startDate:Date = format.date(from: mm.startTime) ?? Date()
            let endDate:Date = format.date(from: mm.endTime) ?? Date()
            lastDateLab.text = "任务期限：\(startDate.month)月\(startDate.day)日-\(endDate.month)月\(endDate.day)日"
            var text = "  待检查  "
            var color:UIColor = .k2CD773
            if mm.taskStatus == 3 {
                text = "  超期未查  "
                color = .kFF6A34
            }
            statusLab.text = text
            statusLab.textColor = color
            statusLab.layer.borderColor = color.cgColor
        }
    }
    
    func createView() {
            
        contentView.addSubviews([nameLab,statusLab,timeLab,lastDateLab])
        
        nameLab.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(12)
        }
        
        statusLab.snp.makeConstraints { make in
            make.centerY.equalTo(nameLab.snp.centerY)
            make.height.equalTo(18)
            make.left.greaterThanOrEqualTo(nameLab.snp.right).offset(8)
            make.right.equalTo(-8)
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
    
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 14)
        lab.textColor = .k2F3856
        return lab
    }()
    lazy var statusLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .kFF6A34
        lab.layer.cornerRadius = 4
        lab.layer.borderWidth = 1
        return lab
    }()
    lazy var timeLab: UILabel = {
        let lab = UILabel()
        lab.text = "任务时间："
        lab.isHidden = true
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .k99A0B6
        return lab
    }()
    lazy var lastDateLab: UILabel = {
        let lab = UILabel()
        lab.text = "任务期限："
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .k99A0B6
        return lab
    }()
    
}
