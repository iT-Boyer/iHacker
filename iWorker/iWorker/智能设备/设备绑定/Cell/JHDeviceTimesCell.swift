//
//  JHDeviceTimesCell.swift
//  iWorker
//
//  Created by boyer on 2022/3/23.
//

import UIKit
import JHBase

class JHDeviceTimesCell: UITableViewCell {
    
    var startTime = ""{
        willSet(newValue){
            self.start.text = newValue
        }
    }
    var endTime = ""{
        willSet(newValue){
            self.end.text = newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {
        contentView.addSubview(start)
        contentView.addSubview(end)
        contentView.addSubview(line)
        
        start.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.height.equalTo(30)
        }
        
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(8)
            make.center.equalToSuperview()
            make.left.equalTo(start.snp.right).offset(15)
        }
        
        end.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(line.snp.right).offset(15)
            make.right.equalTo(-15)
            make.height.equalTo(30)
        }
    }
    
    private lazy var start: UILabel = {
        return createLab()
    }()
    
    private lazy var end: UILabel = {
        return createLab()
    }()
    private lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .initWithHex("2F3856")
        return line
    }()
    
    private func createLab() -> UILabel {
        let lab = UILabel()
        lab.textColor = .initWithHex("2F3856")
        lab.font = .systemFont(ofSize: 12)
        lab.layer.cornerRadius = 3
        lab.layer.borderWidth = 1
        lab.textAlignment = .center
        lab.layer.borderColor = UIColor.initWithHex("B5B5B5").cgColor
        return lab
    }
    
}
