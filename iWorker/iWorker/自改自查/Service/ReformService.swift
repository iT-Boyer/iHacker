//
//  ReformService.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//

import Foundation
import JHBase
import MBProgressHUD
import SwiftyJSON
import Alamofire

let rootPath = JHBaseDomain.fullURL(with: "api_host_rips", path: "/Jinher.AMP.RIP.SV.ComInspectAssistantSV.svc")

enum Path: String {
    case GetComInspectOptionList
    
    var urlString:String{
        let api = rawValue
        return rootPath + "/" + api
    }
}

class ReformService {
    static let shared : ReformService = ReformService()
    
    private var _header: HTTPHeaders {
        return ["Content-Type" : "application/json; charset=utf-8",
                      "Accept" : "application/json"]

    }
    
    //TODO: 获取检查项清单
    func getComInspectOptionList(completionHandler:@escaping(ServiceResult)->Void) {
        let param:[String:Any] = [:]
        AF.request(Path.GetComInspectOptionList.urlString,
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default, headers: _header).responseJSON { (response) in
            
            var result = ServiceResult()
            result.error = ServiceError.messageError(message: "Unkown error!")
            
            if let error = response.error{
                result.json = nil
                result.error = ServiceError.messageError(message: error.errorDescription ?? "")
            } else {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["IsSuccess"].boolValue{
                        result.json = json
                        result.error = nil
                    }else{
                        result.json = nil
                        let message = json["Message"].stringValue
                        result.error = .messageError(message: message)
                    }
                case .failure(let error):
                    result.json = nil
                    result.error = .messageError(message:error.errorDescription ?? "")
                }
            }
            completionHandler(result)
        }
    }
}
