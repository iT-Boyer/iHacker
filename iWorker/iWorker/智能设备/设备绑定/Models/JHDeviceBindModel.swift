//
//  DeviceBindModel.swift
//  iWorker
//
//  Created by boyer on 2022/3/24.
//

import Foundation
import JHBase

// MARK: - DeviceBindModel
struct JHDeviceBindModel {
    var deviceTypeName = "", deviceTypeID = "", sn = ""
    var workTimeList: [WorkTime]? = []
    var deviceType: Int = 0
    var deviceID = "", name = ""
    var appID = JHBaseInfo.appID, userID = JHBaseInfo.userID

    enum CodingKeys: String, CodingKey {
        case deviceTypeName = "DeviceTypeName"
        case deviceTypeID = "DeviceTypeId"
        case sn = "SN"
        case userID = "UserId"
        case workTimeList = "WorkTimeList"
        case deviceType = "DeviceType"
        case deviceID = "DeviceId"
        case name = "Name"
        case appID = "AppId"
    }
}

// MARK: - WorkTimeList
struct WorkTime: Codable {
    var endTime, startTime: String

    enum CodingKeys: String, CodingKey {
        case endTime = "EndTime"
        case startTime = "StartTime"
    }
}
