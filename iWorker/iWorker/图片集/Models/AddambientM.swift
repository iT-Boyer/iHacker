//
//  AddambientM.swift
//  iWorker
//
//  Created by boyer on 2022/6/10.
//

import Foundation
import SwiftyJSON

struct AddambientM:Codable {
    var storeId,type,isPicList,brandPubId:String?
    var ambientList:[AmbientModel]?
    
    enum CodingKeys: String, CodingKey {
        case ambientList = "AmbientList"
        case storeId = "StoreId"
        case type = "Type"
        case isPicList = "IsPicList"
        case brandPubId = "BrandPubId"
    }
    
    func toParams()->[String:Any] {
        guard let data = try? JSONEncoder().encode(self) else {return [:]}
        guard let params:[String:Any] = JSON(data).dictionaryObject else {return [:]}
        return params
    }
}

struct AmbientModel:Codable {
    var ambientDesc, ambientUrl:String?
    
    enum CodingKeys: String, CodingKey {
        case ambientDesc = "AmbientDesc"
        case ambientUrl = "AmbientUrl"
    }
}
