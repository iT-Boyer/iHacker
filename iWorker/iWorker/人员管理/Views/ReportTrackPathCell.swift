//
//  ReportTrackPathCell.swift
//  iWorker
//
//  Created by boyer on 2022/5/31.
//

import Foundation
import UIKit

class ReportTrackPathCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:ReportLocationM?{
        didSet{
            guard let mm = model else{return}
            timeLab.text = mm.reportDate
            addrLab.text = mm.location
        }
    }
    
    func createView() {
        contentView.addSubviews([timeLab,addrLab,line])
        timeLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.left.equalTo(20)
        }
        line.snp.makeConstraints { make in
            make.top.centerY.equalToSuperview()
            make.width.equalTo(10)
            make.left.equalTo(timeLab.snp.right).offset(20)
        }
        addrLab.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerY.equalToSuperview()
            make.left.equalTo(line.snp.right).offset(20)
            make.right.equalTo(-10)
        }
    }
    
    lazy var timeLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .k2F3856
        lab.font = .systemFont(ofSize: 12)
        return lab
    }()
    
    lazy var addrLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .k2F3856
        lab.font = .systemFont(ofSize: 14)
        return lab
    }()
    lazy var line: SplitDotlineView = {
        let line = SplitDotlineView()
        return line
    }()
}
