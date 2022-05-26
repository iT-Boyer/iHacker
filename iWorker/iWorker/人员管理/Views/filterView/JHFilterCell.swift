//
//  ReportMapRightFilterCell.swift
//  iWorker
//
//  Created by boyer on 2022/5/26.
//

import UIKit

class JHFilterCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let icon = UIImageView(image: .init(named: "btnselect"))
    let label = UILabel()
    var model:JHMapFilterM?{
        didSet{
            guard let mm = model else {
                return
            }
            label.text = mm.name
            icon.image = .init(named: "btnselect")
            if mm.selected {
                icon.image = .init(named: "btnselected")
            }
        }
    }
    
    func createView() {
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .initWithHex("")
        
        contentView.addSubviews([icon,label])
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(icon.snp.left).offset(-10)
        }
    }
}
