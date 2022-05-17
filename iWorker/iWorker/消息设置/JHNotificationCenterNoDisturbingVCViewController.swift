//
//  JHNotificationCenterNoDisturbingVCViewController.swift
//  JHNotificationCenterManagerLibrary
//
//  Created by boyer on 2022/5/16.
//  Copyright © 2022 xianjunwang. All rights reserved.
//

import UIKit
import JHBase

class JHNotificationCenterNoDisturbingVCViewController: JHBaseNavVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "免打扰设置"
        createView()
    }
    
    func createView() {
        view.addSubviews([firstView, timeView])
        firstView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(8)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        timeView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom).offset(8)
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        
        let title = UILabel()
        title.textColor = .initWithHex("2F3856")
        title.text = "是否免打扰"
        title.font = .systemFont(ofSize: 16)
        let tip = UILabel()
        tip.textColor = .initWithHex("99A0B6")
        tip.text = "开启后，在设定时间段内收消息不会响铃或振动"
        tip.font = .systemFont(ofSize: 12)
        let switchOn = UISwitch()
        switchOn.onTintColor = .initWithHex("599199")
        switchOn.tintColor = .initWithHex("E9E9EB")
        switchOn.addTarget(self, action: #selector(changeSwitch(switchOn:)), for: .valueChanged)
        
        view.addSubviews([title,tip,switchOn])
        
        title.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalTo(switchOn)
        }
        
        tip.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.left.equalTo(12)
            make.bottom.equalTo(-15)
        }
        
        switchOn.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.top.equalTo(15)
            make.size.equalTo(CGSize(width: 52, height: 31))
        }
        return view
    }()
    
    
    lazy var timeView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        
        let startDate = JHTimeSetingView(title: "开始时间") { tim in
        }
        let endDate = JHTimeSetingView(title: "结束时间") { tim in
        }
        
        let line = UIView()
        line.backgroundColor = .initWithHex("EEEEEE")
        
        view.addSubviews([startDate, line, endDate])
        
        startDate.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(12)
            make.centerX.equalToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(startDate.snp.bottom)
            make.height.equalTo(0.5)
            make.left.centerX.equalToSuperview()
        }
        
        endDate.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom)
            make.left.equalTo(12)
            make.bottom.centerX.equalToSuperview()
        }
        
        return view
    }()
}

extension JHNotificationCenterNoDisturbingVCViewController
{
    @objc
    func changeSwitch(switchOn:UISwitch) {
        timeView.isHidden = !switchOn.isOn
    }
}
