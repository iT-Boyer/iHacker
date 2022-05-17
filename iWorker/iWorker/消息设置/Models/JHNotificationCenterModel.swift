//
//  JHNotificationCenterModel.swift
//  iWorker
//
//  Created by boyer on 2022/5/17.
//

import UIKit

struct JHNotificationCenterModel {
    //业务类型
    var businessType:String?
    //业务ID，群免打扰使用
    var businessID:String?
    //业务名
    var businessName:String?
    //开关状态显示
    var state:String?
    //免打扰状态
    var dndState:String?
    //开始时间
    var startTime:String?
    //结束时间
    var endTime:String?
    
    //cell索引
    var cellIndex = 0
}
