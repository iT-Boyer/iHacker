//
//  JHMapFilterM.swift
//  iWorker
//
//  Created by boyer on 2022/5/26.
//

import Foundation

// MARK: - JHMapFilterM
struct JHMapFilterM: Codable {
    let id, name, parentID: String
    let level: Int
    
    var selected = false
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case parentID = "ParentId"
        case level = "Level"
    }
    
    // 解析
    static func parsed<T:Decodable>(data:Data) -> T {
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            fatalError(#function+"解析失败：\(error)")
        }
    }
}
