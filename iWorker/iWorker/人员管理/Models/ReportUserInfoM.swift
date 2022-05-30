//
//  ReportUserInfoM.swift
//  iWorker
//
//  Created by boyer on 2022/5/30.
//

import Foundation

// MARK: - DataClass
struct ReportUserInfoM: Codable {
    let areaNames: [String]
    let employeeID, employeeName: String
    let employeeHeadIcon: String
    let employeeMobile, departmentID, departmentName: String

    enum CodingKeys: String, CodingKey {
        case areaNames = "AreaNames"
        case employeeID = "EmployeeId"
        case employeeName = "EmployeeName"
        case employeeHeadIcon = "EmployeeHeadIcon"
        case employeeMobile = "EmployeeMobile"
        case departmentID = "DepartmentId"
        case departmentName = "DepartmentName"
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
