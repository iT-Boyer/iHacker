//
//  FlagStatusModel.swift
//  iWorker
//
//  Created by boyer on 2022/5/30.
//

import Foundation
// MARK: - FlagStatusModel
struct FlagStatusModel: Codable {
    let statisticaStatus: Int
    let statisticaName, statisticaDesc: String
    let statisticaCount: Int

    enum CodingKeys: String, CodingKey {
        case statisticaStatus = "StatisticaStatus"
        case statisticaName = "StatisticaName"
        case statisticaDesc = "StatisticaDesc"
        case statisticaCount = "StatisticaCount"
    }
    
    // 解析
    static func parsed<T:Decodable>(data:Data) -> T? {
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }catch{
            return nil
        }
    }
}
