//
//  JHPatrolTaskModel.swift
//  iWorker
//
//  Created by boyer on 2022/5/30.
//

import Foundation

struct PatrolTaskModel:Codable {
    
    let StoreId:String
    let PersonnelId:String
    let PatrolSubTasksId:String
    let StoreName:String
    let StoreAddress:String

    let StoreTel:String
    let Personnel:String
    let StartTime:String
    let EndTime:String
    let TaskName:String

    let ProcessResult:String//通过或者合格
    
    let AppId:String
    let TaskId:String
    let Distance:String
    let RequestStatus:String
    let StoreSecTypeId:String
    let StoreSecTypeRemark:String

    let DistanceRemark:String
    let DayRemark:String
    let StoreAddressRemark:String
    let StoreTelRemark:String
    let StartTimeRemark:String
    let EndTimeRemark:String
    
    let Picture:[String]
    let isBtnSelect:Bool
    let EntityTypeCode:String
    
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
