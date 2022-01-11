//
//  JHUnitOrgBaseModel.swift
//  iWorker
//
//  Created by boyer on 2022/1/10.
//

import UIKit
import GRDB

class JHUnitOrgBaseModel: NSObject,Codable {

    var storeId:String!
    var companyName:String!
    var address:String!
    var creditCode:String!
    var licenceCode:String!
    
    //标识选中状态
    var selected:Bool?
    
    static func parsed<T:Decodable>(data:Data) -> T {
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            fatalError(#function+"解析失败：\(error)")
        }
    }
}
