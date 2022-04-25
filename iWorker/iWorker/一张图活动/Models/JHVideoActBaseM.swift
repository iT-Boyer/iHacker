//
//  JHVideoActBaseM.swift
//  iWorker
//
//  Created by boyer on 2022/4/25.
//

import UIKit

// MARK: - JHVideoActBaseM
struct JHVideoActBaseM: Codable {
    let data: [Datum]
    let isSuccess: Bool
    let message: String

    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case isSuccess = "IsSuccess"
        case message = "Message"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let id, userName, activityName, activityPath: String
    let activityImagePath: String
    let activityStartDate, activityEndDate: String
    let activityStatus, activityProgress, joinCount: Int
    let activitySubDate: String

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
