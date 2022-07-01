//
//  CheckReportModel.swift
//  iWorker
//
//  Created by boyer on 2022/7/1.
//

import Foundation

// MARK: - Content
struct CheckReportModel: Codable {
    var completeDate, inspectDate, inspectTypeID, inspectTypeName: String?
    var isReform: Bool?
    var storeID, storeName, storeSECTypeName, storeTypeName: String?
    var yearTimes: Int?
    var authUserProfile: [String]?
    var insOpts: [ReformOptionModel]?
    var reformSignature: [ReformSignModel]?
    var remark: String?
    var signature: String?

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
        case authUserProfile = "AuthUserProfile"
        case insOpts = "InsOpts"
        case reformSignature = "ReformSignature"
        case remark = "Remark"
        case signature = "Signature"
    }
}

// MARK: - InsOpt
struct ReformOptionModel: Codable {
    var id: String?
    var pics: String?
    var remark, signature: String?
    var status: Int?
    var text: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case pics = "Pics"
        case remark = "Remark"
        case signature = "Signature"
        case status = "Status"
        case text = "Text"
    }
}

// MARK: - ReformSignature
struct ReformSignModel: Codable {
    var remark: String?
    var roleName: String?
    var signature: String?

    enum CodingKeys: String, CodingKey {
        case remark = "Remark"
        case roleName = "RoleName"
        case signature = "Signature"
    }
}
