//
//  SaveRecordModel.swift
//  iWorker
//
//  Created by boyer on 2022/6/30.
//

import Foundation
import SwiftyJSON

/// 生成报告模型类
struct AddSelfInsModel:Codable {
    var record:AddRecordModel?
    var options:[AddInsOptModel]?
    var profiles:[String]?          //五定拍照图片数组
  
    
    func toParams()->[String:Any] {
        guard let data = try? JSONEncoder().encode(self) else {return [:]}
        guard let params:[String:Any] = JSON(data).dictionaryObject else {return [:]}
        return params
    }

    // 解析
    static func unArchive() -> AddSelfInsModel?{
        do{
            guard let url = arcchiveUrl else { return nil}
            let jsonData = try Data(contentsOf: url,
                                       options: NSData.ReadingOptions(rawValue: 0))
            let decoder = JSONDecoder()
            return try decoder.decode(AddSelfInsModel.self, from: jsonData)
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
            guard let url = AddSelfInsModel.arcchiveUrl else { return}
            try menuJson.write(to: url, options: .atomic)
        }catch{
            print("归档失败...")
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
        let newfile = documentDir + "/record.json"
        let url = URL(fileURLWithPath: newfile)
        return url
    }
}

struct AddRecordModel: Codable {
    var storeId, userId, appId: String?
    var inspectDate: String?
    var location: String?
    var latitude, longitude:Double?
    var remark, inspectSignature:String?
    var selfInspectTypeId, selfInspectType: String?
    
    enum CodingKeys: String, CodingKey {
        case storeId = "StoreId"
        case userId = "UserId"
        case appId = "AppId"
        case inspectDate = "InspectDate"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case location = "Location"
        case remark = "Remark"
        case inspectSignature = "InspectSignature"
        case selfInspectType = "SelfInspectType"
        case selfInspectTypeId = "SelfInspectTypeId"
    }
}

struct AddInsOptModel:Codable, Equatable {
    
    static func == (lhs: AddInsOptModel, rhs: AddInsOptModel) -> Bool {
        return lhs.inspectOptionId == rhs.inspectOptionId
    }
    
    
    var inspectOptionId:String?
    var picture: String?    // picture ;分号分割的图片路径
    var status: Int? = 0    // 0:未通过 1:通过 2:可选

    var origin:InspectOptionModel?{
        willSet{
            inspectOptionId = newValue?.id
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case inspectOptionId = "InspectOptionId"
        case picture = "Picture"
        case status = "Status"
        case origin = "origin"
    }
    
    var pictures:[JHCameraModel]?{
        guard let picurls = picture, !picurls.isEmpty else { return nil }
        
        if picurls.contains(";") {
            let pics = picurls.components(separatedBy: ";").compactMap({ pic -> JHCameraModel? in
                let model = JHCameraModel(url: pic)
                return model
            })
            return pics
        }else{
            let model = JHCameraModel(url: picurls)
            return [model]
        }
    }
}
