//
//  JHPatrolTaskModel.swift
//  iWorker
//
//  Created by boyer on 2022/5/30.
//

import Foundation

struct PatrolTaskModel:Codable {
    
    let appID, storeID, taskID, patrolSubTasksID: String
    let storeName, storeAddress, storeTel, personnelID: String
    let personnel, startTime, endTime, taskName: String
    let processResult: String
    let picture: [String]
    let distance: Int
    let completeTime: String
    let requestStatus: Int
    let storeSECTypeID, storeSECTypeRemark, entityTypeCode, distanceRemark: String
    let dayRemark, storeAddressRemark, storeTelRemark, startTimeRemark: String
    let endTimeRemark: String

    enum CodingKeys: String, CodingKey {
        case appID = "AppId"
        case storeID = "StoreId"
        case taskID = "TaskId"
        case patrolSubTasksID = "PatrolSubTasksId"
        case storeName = "StoreName"
        case storeAddress = "StoreAddress"
        case storeTel = "StoreTel"
        case personnelID = "PersonnelId"
        case personnel = "Personnel"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case taskName = "TaskName"
        case processResult = "ProcessResult"
        case picture = "Picture"
        case distance = "Distance"
        case completeTime = "CompleteTime"
        case requestStatus = "RequestStatus"
        case storeSECTypeID = "StoreSecTypeId"
        case storeSECTypeRemark = "StoreSecTypeRemark"
        case entityTypeCode = "EntityTypeCode"
        case distanceRemark = "DistanceRemark"
        case dayRemark = "DayRemark"
        case storeAddressRemark = "StoreAddressRemark"
        case storeTelRemark = "StoreTelRemark"
        case startTimeRemark = "StartTimeRemark"
        case endTimeRemark = "EndTimeRemark"
    }
    
    // 解析
    static func parsed<T:Decodable>(data:Data) -> T? {
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            return nil
        }
    }
}
