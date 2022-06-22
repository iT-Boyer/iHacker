//
//  JHPhotosModel.swift
//  iWorker
//
//  Created by boyer on 2022/6/8.
//

import Foundation

// MARK: - Content
struct JHPhotosModel: Codable {
    var brandPubID, picDES, picURL: String?
    var isPicList: Bool = false
    var picTotal: Int = 0

    enum CodingKeys: String, CodingKey {
        case brandPubID = "BrandPubId"
        case picDES = "PicDes"
        case picURL = "PicUrl"
        case isPicList = "IsPicList"
        case picTotal = "PicTotal"
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
