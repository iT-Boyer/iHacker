//
//  InsOneMonthModel.swift
//  iWorker
//
//  Created by boyer on 2022/7/8.
//

import Foundation

// MARK: - Content
struct InsOneMonthModel: Codable {
    var comInspectDayList: [InspectDayModel]?
    var comInspectRecordList: [InspectRecordModel]?

    enum CodingKeys: String, CodingKey {
        case comInspectDayList = "ComInspectDayList"
        case comInspectRecordList = "ComInspectRecordList"
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

// MARK: - COMInspectDayList
struct InspectDayModel: Codable {
    var inspectDate: String?

    enum CodingKeys: String, CodingKey {
        case inspectDate = "InspectDate"
    }
}

// MARK: - COMInspectRecordList
struct InspectRecordModel: Codable {
    var id, inspectDate, selfInspectType, selfInspectTypeID: String?
    var userName: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case inspectDate = "InspectDate"
        case selfInspectType = "SelfInspectType"
        case selfInspectTypeID = "SelfInspectTypeId"
        case userName = "UserName"
    }
}
