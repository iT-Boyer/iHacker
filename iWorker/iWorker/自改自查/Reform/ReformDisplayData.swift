//
//  ReformDisplayData.swift
//  iWorker
//
//  Created by boyer on 2022/7/18.
//
//

import Foundation
import Viperit

// MARK: - ReformDisplayData class
final class ReformDisplayData: DisplayData {
    
    // MARK: - 两个单元的数据结构
    var firstArray:[ReformTaskModel]?
    var secondArray:[ReformTaskModel]?
    
    var tableData:[[ReformTaskModel]?]{
        [firstArray,secondArray]
    }
}

// MARK: -
struct ReformCommonModel: Codable,BaseModel {
    var content: [ReformTaskModel]?
    var businessCode, message: String?
    var isSuccess: Bool
    var code: String?
    var data: String?
    var detail: String?

    enum CodingKeys: String, CodingKey {
        case content = "Content"
        case businessCode = "BusinessCode"
        case message = "Message"
        case isSuccess = "IsSuccess"
        case code = "Code"
        case data = "Data"
        case detail = "Detail"
    }
    
    // 解析
    static func parsed<T:Decodable>(data:Data) -> T?{
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            return nil
        }
    }
}

// MARK: - Content
struct ReformTaskModel: Codable {
    var classificationName, classificationID: String?
    var classOrder: Int?
    var comInspectOptionList: [SuperComInspectOption]?
    var isCompleted, isJumpList: Bool?

    enum CodingKeys: String, CodingKey {
        case classificationName = "ClassificationName"
        case classificationID = "ClassificationId"
        case classOrder = "ClassOrder"
        case comInspectOptionList = "ComInspectOptionList"
        case isCompleted = "IsCompleted"
        case isJumpList = "IsJumpList"
    }
    
    // 解析
    static func parsed<T:Decodable>(data:Data) -> T?{
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            return nil
        }
    }
}

// MARK: - SuperComInspectOption
struct SuperComInspectOption: Codable {
    var inspectOptionID, optionTaskID: String?
    var optionTaskIDList: [String]?
    var text: String?
    var remark: String?
    var picture: String?
    var order, classOrder, isForAll: Int?
    var inspectMethod: Int?
    var completionCriteria, noticeTime: String?
    var classificationID, classificationName: String?
    var isCompleted, isVoicePlay, isExecutor: Bool?
    var comInspectOptionGuideList: [COMInspectOptionGuide]?
    var fiveSetType: Int?
    var appID, taskTypeID: String?
    var statusList: [String]?

    enum CodingKeys: String, CodingKey {
        case inspectOptionID = "InspectOptionId"
        case optionTaskID = "OptionTaskId"
        case optionTaskIDList = "OptionTaskIdList"
        case text = "Text"
        case order = "Order"
        case classOrder = "ClassOrder"
        case isForAll = "IsForAll"
        case remark = "Remark"
        case picture = "Picture"
        case inspectMethod = "InspectMethod"
        case completionCriteria = "CompletionCriteria"
        case noticeTime = "NoticeTime"
        case classificationID = "ClassificationId"
        case classificationName = "ClassificationName"
        case isCompleted = "IsCompleted"
        case isVoicePlay = "IsVoicePlay"
        case isExecutor = "IsExecutor"
        case comInspectOptionGuideList = "ComInspectOptionGuideList"
        case fiveSetType = "FiveSetType"
        case appID = "AppId"
        case taskTypeID = "TaskTypeId"
        case statusList = "StatusList"
    }
}

// MARK: - COMInspectOptionGuideList
struct COMInspectOptionGuide: Codable {
    var id, text: String?
    var picture: String?
    var originalPicture: String?
    var order, picType: Int?
    var videoID: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case text = "Text"
        case picture = "Picture"
        case originalPicture = "OriginalPicture"
        case order = "Order"
        case picType = "PicType"
        case videoID = "VideoId"
    }
}
