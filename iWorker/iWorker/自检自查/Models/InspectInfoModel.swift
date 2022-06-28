//
//  InspectInfoModel.swift
//  iWorker
//
//  Created by boyer on 2022/6/28.
//

import Foundation

// MARK: - Content
struct InspectInfoModel: Codable {
    var completeDate: String?
    var inspectDate, inspectTypeID, inspectTypeName: String?
    var isReform: String?
    var storeID, storeName, storeSECTypeName, storeTypeName: String?
    var yearTimes: Int?
    var inspectDateArg: String?
    var inspectTypeList: [InspectType]?
    var storeSECTypeID, storeTypeID: String?
    var userIcon: String?
    var userID, userName: String?

    // 解析
    static func parsed<T:Decodable>(data:Data) -> T?{
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case completeDate = "CompleteDate"
        case inspectDate = "InspectDate"
        case inspectTypeID = "InspectTypeId"
        case inspectTypeName = "InspectTypeName"
        case isReform = "IsReform"
        case storeID = "StoreId"
        case storeName = "StoreName"
        case storeSECTypeName = "StoreSecTypeName"
        case storeTypeName = "StoreTypeName"
        case yearTimes = "YearTimes"
        case inspectDateArg = "InspectDateArg"
        case inspectTypeList = "InspectTypeList"
        case storeSECTypeID = "StoreSecTypeId"
        case storeTypeID = "StoreTypeId"
        case userIcon = "UserIcon"
        case userID = "UserId"
        case userName = "UserName"
    }
}

// MARK: - InspectTypeList
struct InspectType: Codable {
    var id: String?
    var isDefault: Bool?
    var text: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case isDefault = "IsDefault"
        case text = "Text"
    }
}
