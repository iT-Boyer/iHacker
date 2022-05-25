//
//  ReportMapUserTaskStatM.swift
//  iWorker
//
//  Created by boyer on 2022/5/25.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reportLastFootPrintM = try? newJSONDecoder().decode(ReportLastFootPrintM.self, from: jsonData)

import Foundation

// MARK: - ReportLastFootPrintM

// MARK: - DataClass
struct ReportMapUserTaskStatM: Codable {
    let all, waitCheck, checked: Int
    let employeeInfo: ReportMapUserInfoM
    let taskList: [ReportMapUserTaskM]

    enum CodingKeys: String, CodingKey {
        case all = "All"
        case waitCheck = "WaitCheck"
        case checked = "Checked"
        case employeeInfo = "EmployeeInfo"
        case taskList = "TaskList"
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

// MARK: - EmployeeInfo
struct ReportMapUserInfoM: Codable {
    let employeeID, employeeName, employeeHeadIcon, employeeMobile: String
    let departmentID, departmentName: String

    enum CodingKeys: String, CodingKey {
        case employeeID = "EmployeeId"
        case employeeName = "EmployeeName"
        case employeeHeadIcon = "EmployeeHeadIcon"
        case employeeMobile = "EmployeeMobile"
        case departmentID = "DepartmentId"
        case departmentName = "DepartmentName"
    }
}

// MARK: - TaskList
struct ReportMapUserTaskM: Codable {
    let taskID, taskName, subTime, startTime: String
    let endTime: String
    let taskStatus: Int

    enum CodingKeys: String, CodingKey {
        case taskID = "TaskId"
        case taskName = "TaskName"
        case subTime = "SubTime"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case taskStatus = "TaskStatus"
    }
}
