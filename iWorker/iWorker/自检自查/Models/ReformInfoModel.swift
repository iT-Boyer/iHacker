//
//  ReformInfoModel.swift
//  iWorker
//
//  Created by boyer on 2022/7/6.
//

import Foundation
import SwiftyJSON

struct ReformInfoModel:Codable {
    
    var record:ReformRecordModel?
    var options:[ReformOptModel]?
    var signatures:[ReformSignModel]?
    var profiles:[String]?
    
    enum CodingKeys: String, CodingKey {
        case record = "record"
        case options = "options"
        case signatures = "signatures"
        case profiles = "profiles"
    }
    
    func toParams()->[String:Any] {
        guard let data = try? JSONEncoder().encode(self) else {return [:]}
        guard let params:[String:Any] = JSON(data).dictionaryObject else {return [:]}
        return params
    }

    // 解析
    static func unArchive() -> ReformInfoModel?{
        do{
            let jsonData = try Data(contentsOf: arcchiveUrl,
                                       options: NSData.ReadingOptions(rawValue: 0))
            let decoder = JSONDecoder()
            return try decoder.decode(ReformInfoModel.self, from: jsonData)
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
            try menuJson.write(to: ReformInfoModel.arcchiveUrl, options: .atomic)
        }catch{
            print("归档失败...")
        }
    }
    static func clearArchive() {
        if FileManager.default.fileExists(atPath: arcchiveUrl.path) {
            guard let _ = try? FileManager.default.removeItem(at: arcchiveUrl) else{
                print("删除失败:\(arcchiveUrl.path)")
                return
            }
        }
    }
    static var arcchiveUrl: URL{
        //写入新文件
        let newfile = Bundle.main.bundlePath + "report.json"
        let url = URL(fileURLWithPath: newfile)
        return url
    }
    
}

struct ReformRecordModel:Codable {
    var id, appId, waterMark:String?
    var isComplete:Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case appId = "AppId"
        case waterMark = "WaterMark"
        case isComplete = "IsComplete"
    }
}

struct ReformOptModel:Codable {
    
    var inspectOptionId, inspectSignature, remark:String?
    
    enum CodingKeys: String, CodingKey {
        case inspectOptionId = "InspectOptionId"
        case inspectSignature = "InspectSignature"
        case remark = "Remark"
    }
}
