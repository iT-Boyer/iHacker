//
//  JHVideoActBaseM.swift
//  iWorker
//
//  Created by boyer on 2022/4/25.
//

import UIKit

// MARK: - JHActivityModel
struct JHActivityModel: Codable {
    
    let id, userName, activityName, activityPath: String
    let activityImagePath: String
    let activityStartDate, activityEndDate: String
    let activityStatus, activityProgress, joinCount: Int
    let activitySubDate: String

    // 解析
    static func parsed<T:Decodable>(data:Data) -> T {
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            fatalError(#function+"解析失败：\(error)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case userName = "UserName"
        case activityName = "ActivityName"
        case activityPath = "ActivityPath"
        case activityImagePath = "ActivityImagePath"
        case activityStartDate = "ActivityStartDate"
        case activityEndDate = "ActivityEndDate"
        case activityStatus = "ActivityStatus"
        case activityProgress = "ActivityProgress"
        case joinCount = "JoinCount"
        case activitySubDate = "ActivitySubDate"
    }
}
