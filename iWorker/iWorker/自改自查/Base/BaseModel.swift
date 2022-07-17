//
//  BaseModel.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//

import Foundation

struct ResponseModel {
    var json: [String: Any]
}

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
    var data: ResponseModel?
    var error: ServiceError?
}


protocol BaseModel {}

protocol BaseAction {
    func receivedResponse(_ data: BaseModel?)
    func receivedError(_ error: ServiceError)
}

