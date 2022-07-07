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
    
    // 解档
    static func unArchive() -> InspectInfoModel?{
        do{
            guard let url = arcchiveUrl else { return nil }
            let jsonData = try Data(contentsOf: url,
                                       options: NSData.ReadingOptions(rawValue: 0))
            let decoder = JSONDecoder()
            return try decoder.decode(InspectInfoModel.self, from: jsonData)
        }catch{
            return nil
        }
    }
    // 归档
    func toArchive() {
        do{
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let menuJson = try jsonEncoder.encode(self)
            guard let url = InspectInfoModel.arcchiveUrl else { return}
            try menuJson.write(to: url, options: .atomic)
        }catch{
            print("归档失败...\(error.localizedDescription)")
        }
    }
    
    static func clearArchive() {
        guard let url = arcchiveUrl else { return}
        if FileManager.default.fileExists(atPath: url.path) {
            guard let _ = try? FileManager.default.removeItem(at: url) else{
                print("删除失败:\(url.path)")
                return
            }
        }
    }
    static var arcchiveUrl: URL?{
        //写入新文件
        guard let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        let newfile = documentDir + "/selfinfo.json"
        let url = URL(fileURLWithPath: newfile)
        return url
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
