//
//  JHNotificationCenterCell.swift
//  iWorker
//
//  Created by boyer on 2022/5/17.
//

import UIKit
import JHBase

class JHNotificationCenterCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var model:JHNotificationCenterModel!{
        didSet{
            arrow.isHidden = true
            state.isHidden = true
            switchOn.isHidden = true
            title.text = model.businessName
            switchOn.isOn = model.state == "开启"
            line.isHidden = model.cellIndex == 0
            
            if model.businessName == "消息提醒通知" {
                state.isHidden = false
                state.text = "已关闭"
                if model.state == "开启" {
                    state.text = "已开启"
                }
            }
            
            if model.businessName == "免打扰设置" {
                arrow.isHidden = false
            }
            
            if model.businessName == "铃声" {
                state.isHidden = false
                state.text = "跟随系统"
            }
            
            if model.businessName == "声音提醒"
                || model.businessName == "震动提醒"{
                switchOn.isHidden = false
                switchOn.isOn = false
                if model.state == "开启" {
                    switchOn.isOn = true
                }
                switchOn.setOn(switchOn.isOn, animated: true)
            }
            
            
        }
    }
    
    func createView() {
        
        let stackView = UIStackView(arrangedSubviews: [arrow,state,switchOn])
        stackView.distribution = .fill
        contentView.addSubviews([title, stackView, line])
        
        title.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-12)
            make.height.equalTo(31)
        }

        line.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.height.equalTo(0.5)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .initWithHex("EEEEEE")
        return line
    }()
    
    lazy var arrow: UIImageView = {
        let arrow = UIImageView(image: .init(named:"unittarrow"))
        arrow.contentMode = .scaleAspectFit
        return arrow
    }()
    
    lazy var state: UILabel = {
        let state = UILabel()
        state.textColor = .initWithHex("99A0B6")
        state.font = .systemFont(ofSize: 14)
        state.textAlignment = .right
        return state
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16)
        title.textColor = .initWithHex("2F3856")
        return title
    }()
    
    lazy var switchOn: UISwitch = {
        let sw = UISwitch()
        sw.isOn = true
        sw.onTintColor = .initWithHex("599199")
        sw.tintColor = .initWithHex("E9E9EB")
        sw.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 52, height: 31))
        }
        sw.addTarget(self, action: #selector(switchAction(switch:)), for: .touchDown)
        return sw
    }()
}

extension JHNotificationCenterCell
{
    @objc
    func switchAction(switch:UISwitch) {
        
    }
}
