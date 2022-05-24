//
//  ReportLastFootPrintM.swift
//  iWorker
//
//  Created by boyer on 2022/5/24.
//

import Foundation

// MARK: - ReportLastFootM
struct ReportLastFootM: Codable {
    let id, userID, userName, userTel: String
    let userHeadIcon: String
    let departmentID: String
    let longitude, latitude: Double
    let reportDate, reportDateRemark, reportTime, location: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case userID = "UserId"
        case userName = "UserName"
        case userTel = "UserTel"
        case userHeadIcon = "UserHeadIcon"
        case departmentID = "DepartmentId"
        case longitude = "Longitude"
        case latitude = "Latitude"
        case reportDate = "ReportDate"
        case reportDateRemark = "ReportDateRemark"
        case reportTime = "ReportTime"
        case location = "Location"
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
