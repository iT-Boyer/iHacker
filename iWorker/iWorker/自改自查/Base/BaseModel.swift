//
//  BaseModel.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//

import Foundation
import SwiftyJSON

enum ServiceError: Error {
    case messageError(message: String)
    
    var message: String {
        switch self {
        case .messageError(let message):
            return message
        }
    }
}

struct ServiceResult {
    var json: JSON?
    var error: ServiceError?
    
    var data:Data?{
        guard let origin = json else { return nil }
        if let raw = try? origin.rawData(){
            return raw
        }
        return nil
    }
}


protocol BaseModel {}

