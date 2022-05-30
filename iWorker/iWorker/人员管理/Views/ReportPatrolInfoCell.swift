//
//  ReportPatrolInfoCell.swift
//  iWorker
//
//  Created by boyer on 2022/5/30.
//

import UIKit
import JHBase

struct ReportPatrolInfoM:Codable {
    
}

class ReportPatrolInfoCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let renLab = UILabel()
    let dateLab = UILabel()
    var model:PatrolTaskModel?{
        didSet{
            guard let mm = model else { return }
            titleLab.text = mm.StoreName
            addrLab.text = mm.StoreAddress
            telLab.text = mm.StoreTel
            taskLab.text = mm.TaskName
            renLab.text = mm.Personnel
            dateLab.text = mm.StartTimeRemark + "-" + mm.EndTimeRemark
        }
    }
    func createView()
    {
        let icon = UIImageView(image: .init(named: "address"))
        let icon2 = UIImageView(image: .init(named: "enforceTel"))
        contentView.addSubviews([titleLab,typeLab,icon,icon2,addrLab,telLab,taskLab,renLab,dateLab])
        titleLab.snp.makeConstraints { make in
            make.left.top.equalTo(8)
        }
        typeLab.snp.makeConstraints { make in
            make.right.equalTo(10)
            make.size.equalTo(CGSize(width: 50, height: 22))
            make.centerY.equalTo(titleLab.snp.centerY)
        }
        
        icon.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(8)
            make.left.equalTo(8)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        addrLab.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(8)
            make.right.equalTo(-8)
            make.left.equalTo(icon.snp.right).offset(8)
        }
        icon2.snp.makeConstraints { make in
            make.top.equalTo(addrLab.snp.bottom).offset(8)
            make.left.equalTo(8)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        telLab.snp.makeConstraints { make in
            make.top.equalTo(addrLab.snp.bottom).offset(8)
            make.right.equalTo(-8)
            make.left.equalTo(icon2.snp.right).offset(8)
        }
        taskLab.snp.makeConstraints { make in
            make.top.equalTo(telLab.snp.bottom).offset(15)
            make.left.equalTo(8)
            make.right.equalTo(-8)
        }
        renLab.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.top.equalTo(taskLab.snp.bottom).offset(8)
            make.right.equalTo(-8)
        }
        dateLab.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.top.equalTo(renLab.snp.bottom).offset(8)
            make.right.equalTo(-8)
            make.bottom.equalTo(-10)
        }
    }
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .k2F3856
        lab.font = .systemFont(ofSize: 15)
        return lab
    }()
    
    lazy var typeLab: UILabel = {
        let lab = UILabel()
        lab.text = "   巡查"
        lab.font = .systemFont(ofSize: 11)
        lab.layer.cornerRadius = 11
        lab.layer.borderWidth = 1
        lab.layer.borderColor = UIColor.k428BFE.cgColor
        lab.textColor = .k428BFE
        return lab
    }()
    
    lazy var addrLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .k5E637B
        lab.font = .systemFont(ofSize: 13)
        return lab
    }()
    lazy var telLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.textColor = .k5E637B
        lab.font = .systemFont(ofSize: 13)
        return lab
    }()
    lazy var taskLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .k2F3856
        lab.font = .systemFont(ofSize: 14)
        return lab
    }()
}
