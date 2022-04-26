//
//  JHVideoActBaseM.swift
//  iWorker
//
//  Created by boyer on 2022/4/25.
//

import UIKit

enum ActivityStatus {
    case None
    case Apply  //审核中
    case Fail   //审核失败
    case Wait   //未开始
    case Ing    //进行中/审核通过
    case Over   //已结束
}

// MARK: - JHActivityModel
struct JHActivityModel: Codable {
    
    let id, userName, activityName, activityPath: String
    let activityImagePath: String
    let activityStartDate, activityEndDate: String
    let activityStatus, activityProgress, joinCount: Int
    let activitySubDate: String

    var status:ActivityStatus?{
        var state:ActivityStatus = .None
        if (activityStatus == 0) {
            state = .Apply
        }else if(activityStatus == 1){
            // 审核通过
            switch (activityProgress) {
                case 0:
                    state = .Wait
                    break;
                case 1:
                    state = .Ing
                    break;
                case 2:
                    state = .Over
                    break;
                default:
                    break;
            }
        }else{
                state = .Fail
        }
        return state
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
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case userName = "UserName"
        case activityName = "ActivityName"
        case activityPath = "ActivityPath"
        case activityImagePath = "ActivityImagePath"
        case activityStartDate = "ActivityStartDate"
        case activityEndDate = "ActivityEndDate"
        case activityStatus = "ActivityStatus"
        case activityProgress = "ActivityProgress"
        case joinCount = "JoinCount"
        case activitySubDate = "ActivitySubDate"
    }
}
