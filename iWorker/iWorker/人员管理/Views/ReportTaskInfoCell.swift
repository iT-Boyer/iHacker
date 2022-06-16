//
//  ReportTaskInfoCell.swift
//  iWorker
//
//  Created by boyer on 2022/5/30.
//

import UIKit

class ReportTaskInfoCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let renLab = UILabel()
    let dateLab = UILabel()
    
    var model:ReportTaskModel?{
        didSet{
            guard let mm = model else {
                return
            }
            titleLab.text = mm.eventName
            addrLab.text = mm.questionFixedLocation
            let textattr:[NSAttributedString.Key:Any] = [
                .foregroundColor:UIColor.k99A0B6,
                .font:UIFont.systemFont(ofSize: 13)
            ]
            let textendattr:[NSAttributedString.Key:Any] = [
                .foregroundColor:UIColor.k2F3856,
                .font:UIFont.systemFont(ofSize: 13)
            ]
            let rentext = NSAttributedString(string: "负责人员：\(mm.chargeName)",attributes: textattr)
            renLab.attributedText = rentext.applying(attributes: textendattr, toRangesMatching: mm.chargeName)
            let time = mm.questionSubDateFormat+"-"+mm.questionOffDateFormat
            let timetext = NSAttributedString(string: "有效时间：\(time)",attributes: textattr)
            dateLab.attributedText = timetext.applying(attributes: textendattr, toRangesMatching: time)
        }
    }
    
    
    func createView()
    {
        let icon = UIImageView(image: .init(named: "address"))
        contentView.addSubviews([titleLab,typeLab,icon,addrLab,renLab,dateLab])
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
            make.centerY.equalTo(icon.snp.centerY)
            make.right.equalTo(-8)
            make.left.equalTo(icon.snp.right).offset(8)
        }
       
        renLab.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.top.equalTo(addrLab.snp.bottom).offset(8)
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
        lab.text = "   上报"
        lab.textColor = .k2CD773
        lab.font = .systemFont(ofSize: 11)
        lab.layer.cornerRadius = 11
        lab.layer.borderWidth = 1
        lab.layer.borderColor = UIColor.k2CD773.cgColor
        return lab
    }()
    
    lazy var addrLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .k5E637B
        lab.font = .systemFont(ofSize: 13)
        return lab
    }()
}
