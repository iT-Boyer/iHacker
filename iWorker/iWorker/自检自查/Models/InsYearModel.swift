//
//  InsYearModel.swift
//  iWorker
//
//  Created by boyer on 2022/7/8.
//

import Foundation

// MARK: - Content
struct InsYearModel: Codable {
    var allTimes, byMethod, inspectTimes: Int?
    var selfInspectType, selfInspectTypeID: String?
    var times: Int?

    enum CodingKeys: String, CodingKey {
        case allTimes = "AllTimes"
        case byMethod = "ByMethod"
        case inspectTimes = "InspectTimes"
        case selfInspectType = "SelfInspectType"
        case selfInspectTypeID = "SelfInspectTypeId"
        case times = "Times"
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
