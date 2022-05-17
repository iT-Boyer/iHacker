//
//  JHNotificationCenterManagerViewController.swift
//  JHNotificationCenterManagerLibrary
//
//  Created by boyer on 2022/5/16.
//  Copyright © 2022 xianjunwang. All rights reserved.
//

import UIKit
import JHBase

class JHNotificationCenterManagerViewController: JHBaseNavVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        navTitle = "消息提醒设置"
    }
    
    func createView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.equalTo(12)
            make.bottom.centerX.equalToSuperview()
        }
    }
    
    lazy var tableView: UITableView = {
        let tbl = UITableView(frame: .zero, style: .grouped)
        tbl.delegate = self
        tbl.dataSource = self
        tbl.showsVerticalScrollIndicator = false
        tbl.showsHorizontalScrollIndicator = false
        tbl.backgroundColor = .init(hexString: "F5F5F5")
        tbl.rowHeight = 52
        tbl.sectionFooterHeight = 0
        tbl.sectionHeaderHeight = 0
        tbl.tableFooterView = UIView()
        tbl.separatorStyle = .none
        tbl.register(JHNotificationCenterCell.self, forCellReuseIdentifier: "JHNotificationCenterCell")
        return tbl
    }()
    
    var isReceivePushString: String {
        "开启"
    }
    //TODO: IU平台消息组
    var iuarr:[JHNotificationCenterModel]{
        [JHNotificationCenterModel()]
    }
    
    lazy var businessModelArray: [[JHNotificationCenterModel]] = {
        //创建消息提醒通知模型
        var APNS = createModel(type: "APNS", name: "消息提醒通知")
        //创建免打扰设置模型
        var noDistrubing = createModel(type: "noDistrubing", name: "免打扰设置")
        //创建 声音提醒，铃声，震动提醒模型
        var sound = createModel(type: "soundRemind", name: "声音提醒")
        var ring = createModel(type: "ring", name: "铃声")
        var shock = createModel(type: "shockRemind", name: "震动提醒")
        
        return [[APNS],[noDistrubing],[sound,ring,shock],iuarr]
    }()
}

extension JHNotificationCenterManagerViewController
{
    func createModel(type:String,name:String) -> JHNotificationCenterModel {
        //缓存读取
        //JHNotificationCenterManagerSqlService
        var model:JHNotificationCenterModel
        if let noti = getmodel(type: type) {
            model = noti
        }else{
            model = JHNotificationCenterModel()
            model.businessType = type
            model.businessName = name
        }
        model.state = isReceivePushString
        //TODO: 更新缓存的开关状态
        
        return model
    }
    
    func getmodel(type:String) -> JHNotificationCenterModel? {
        nil
    }
}


extension JHNotificationCenterManagerViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        businessModelArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = businessModelArray[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:JHNotificationCenterCell = tableView.dequeueReusableCell(withIdentifier: "JHNotificationCenterCell") as! JHNotificationCenterCell
        let arr = businessModelArray[indexPath.section]
        var model =  arr[indexPath.row]
        model.cellIndex = indexPath.row
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            let info = Bundle.main.infoDictionary
            let appName:String = info?["CFBundleName"] as! String
            let remaindStr = "如果你要关闭或开启\(appName)的新消息通知，请在iPhone的“设置”-“通知”功能中，找到应用程序“\(appName)”更改"
            return remaindStr
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let notif = JHNotificationCenterNoDisturbingVCViewController()
            self.navigationController?.pushViewController(notif, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //圆角角度
        let radius = 6.0
        cell.backgroundColor = .clear
        //创建layer
        let normalLayer = CAShapeLayer()
        let selectLayer = CAShapeLayer()
        //获取显示区域大小
        let bounds = cell.bounds.insetBy(dx: 0, dy: 0)
        //cell的背景视图
        let normalBgView = UIView(frame: bounds)
        //获取每组行数
        let rowNum = tableView.numberOfRows(inSection: indexPath.section)
        //贝赛尔曲线
        let bezierPath:UIBezierPath!
        if rowNum == 1 {
            //一组有一行（四个角全部为圆角）
            bezierPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: .init(width: radius, height: radius))
            normalBgView.clipsToBounds = false
        }else{
            normalBgView.clipsToBounds = true
            let rect = bounds.inset(by: .init(top: 0, left: 0, bottom: 0, right: 0))
            if indexPath.row == 0 {// 每组第一行（添加左上和右上的圆角）
                normalBgView.frame = rect
                bezierPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: .init(width: radius, height: radius))
            }else if(indexPath.row == rowNum - 1){// 每组最后一行（添加左下和右下的圆角）
                normalBgView.frame = rect
                bezierPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: .init(width: radius, height: radius))
            }else{// 每组不是首位的行不设置圆角
                bezierPath = UIBezierPath.init(rect: bounds)
            }
        }
        // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
        normalLayer.path = bezierPath.cgPath
        selectLayer.path = bezierPath.cgPath
        //设置填充色
        normalLayer.fillColor = UIColor.white.cgColor
        //添加图层到nomalBgView中
        normalBgView.layer.insertSublayer(normalLayer, at: 0)
        normalBgView.backgroundColor = .clear
        cell.backgroundView = normalBgView
        
        //替换cell点击效果
        let selectBgView = UIView.init(frame: bounds)
        selectLayer.fillColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        selectBgView.layer.insertSublayer(selectLayer, at: 0)
        selectBgView.backgroundColor = .clear
        cell.selectedBackgroundView = selectBgView
    }
}
