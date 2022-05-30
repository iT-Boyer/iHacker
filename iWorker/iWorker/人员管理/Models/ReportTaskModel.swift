//
//  ReportByStatusModel.swift
//  iWorker
//
//  Created by boyer on 2022/5/30.
//

import Foundation

struct ReportTaskModel:Codable {
    
    let id, classifyID, classifyName, eventName: String
    let questionStatus: Int
    let questionStatusDesc, questionSubDate, questionOffDate, chargeName: String
    let operationName, operationDate, completeName, completeDate: String
    let questionOffDateFormat, questionSubDateFormat, appID, eventID: String
    let questionDesc, questionThumbnailIcon, questionIcon, questionLocationIcon: String
    let questionReporterCode, questionReporterName, questionAreaName, questionFixedLocation: String
    let questionFixedLongitude, questionFixedLatitude, forPage: Int
    let questionIdentify: String
    let questionSource: Int
    let questionSourceID, questionParentID: String
    let questionIsRawData: Bool

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case classifyID = "ClassifyId"
        case classifyName = "ClassifyName"
        case eventName = "EventName"
        case questionStatus = "QuestionStatus"
        case questionStatusDesc = "QuestionStatusDesc"
        case questionSubDate = "QuestionSubDate"
        case questionOffDate = "QuestionOffDate"
        case chargeName = "ChargeName"
        case operationName = "OperationName"
        case operationDate = "OperationDate"
        case completeName = "CompleteName"
        case completeDate = "CompleteDate"
        case questionOffDateFormat = "QuestionOffDateFormat"
        case questionSubDateFormat = "QuestionSubDateFormat"
        case appID = "AppId"
        case eventID = "EventId"
        case questionDesc = "QuestionDesc"
        case questionThumbnailIcon = "QuestionThumbnailIcon"
        case questionIcon = "QuestionIcon"
        case questionLocationIcon = "QuestionLocationIcon"
        case questionReporterCode = "QuestionReporterCode"
        case questionReporterName = "QuestionReporterName"
        case questionAreaName = "QuestionAreaName"
        case questionFixedLocation = "QuestionFixedLocation"
        case questionFixedLongitude = "QuestionFixedLongitude"
        case questionFixedLatitude = "QuestionFixedLatitude"
        case forPage = "ForPage"
        case questionIdentify = "QuestionIdentify"
        case questionSource = "QuestionSource"
        case questionSourceID = "QuestionSourceId"
        case questionParentID = "QuestionParentId"
        case questionIsRawData = "QuestionIsRawData"
    }
    
    // 解析
    static func parsed<T:Decodable>(data:Data) -> T {
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            fatalError(#function+"解析失败：\(error)")
        }
    }
}
