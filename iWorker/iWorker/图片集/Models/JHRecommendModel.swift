//
//  JHRecommendModel.swift
//  iWorker
//
//  Created by boyer on 2022/6/8.
//

import Foundation

struct JHRecommendModel: Codable {
    var imageURL, name: String?
    var price: Int
    var businessRecommendID: String?
    var sort: Int
    var elePlatID, elePctIntr: String?

    var selected = false
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case name, price
        case businessRecommendID = "businessRecommendId"
        case sort
        case elePlatID = "elePlatId"
        case elePctIntr
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
