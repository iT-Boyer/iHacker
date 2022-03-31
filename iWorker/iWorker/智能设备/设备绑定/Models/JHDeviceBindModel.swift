//
//  DeviceBindModel.swift
//  iWorker
//
//  Created by boyer on 2022/3/24.
//

import Foundation
import JHBase

// MARK: - DeviceBindModel
struct JHDeviceBindModel:Codable {
    var deviceTypeName:String?, deviceTypeID:String?, sn:String?, storeId:String?
    var workTimeList: [WorkTime]? = []
    var deviceType: Int? = 0
    var deviceID:String?, name:String? = ""
    var appID:String? = JHBaseInfo.appID, userID:String? = JHBaseInfo.userID

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
        case storeId = "StoreId"
    }
    static func parsed<T:Decodable>(data:Data) -> T {
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            fatalError(#function+"解析失败：\(error)")
        }
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
