//
//  StoreAmbientModel.swift
//  iWorker
//
//  Created by boyer on 2022/6/8.
//

import Foundation

// MARK: - StoreAmbientModel
struct StoreAmbientModel: Codable {
    var ambientDesc, ambientURL, ambientID: String?

    enum CodingKeys: String, CodingKey {
        case ambientDesc = "AmbientDesc"
        case ambientURL = "AmbientUrl"
        case ambientID = "AmbientId"
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
