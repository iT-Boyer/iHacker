//
//  InspectOtionModel.swift
//  iWorker
//
//  Created by boyer on 2022/6/29.
//

import Foundation

// MARK: - Content
struct InspectOptionModel: Codable {
    var id: String?
    var isNeedPic, isNotForAll: Bool?
    var text: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case isNeedPic = "IsNeedPic"
        case isNotForAll = "IsNotForAll"
        case text = "Text"
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
