//
//  ReportLocationListM.swift
//  iWorker
//
//  Created by boyer on 2022/5/31.
//
import Foundation

// MARK: - DataClass
struct ReportTrackPachM: Codable {
    let id, userID, userName, userTel: String
    let userHeadIcon: String
    let departmentID, minDate: String
    let locationList: [ReportLocationM]

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case userID = "UserId"
        case userName = "UserName"
        case userTel = "UserTel"
        case userHeadIcon = "UserHeadIcon"
        case departmentID = "DepartmentId"
        case minDate = "MinDate"
        case locationList = "LocationList"
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

// MARK: - LocationList
struct ReportLocationM: Codable {
    let reportDate, reportDateRemark, reportTime: String
    let longitude, latitude: Int
    let location: String

    enum CodingKeys: String, CodingKey {
        case reportDate = "ReportDate"
        case reportDateRemark = "ReportDateRemark"
        case reportTime = "ReportTime"
        case longitude = "Longitude"
        case latitude = "Latitude"
        case location = "Location"
    }
}
