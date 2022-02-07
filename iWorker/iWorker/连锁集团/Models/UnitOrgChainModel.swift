//
//  UnitOrgChainModel.swift
//  iWorker
//
//  Created by boyer on 2022/1/10.
//

import UIKit
import SwiftyJSON

class UnitOrgChainModel: NSObject {
    var account:String!
    var storeId:String!
    var appId:String!
    var bindStoreList:[UnitOrgStoreModel] = []
    var state:Int!
    
    var dataJ:[String:Any]{
        var root:[String:Any] = ["account":account ?? "",
                                 "storeId":storeId ?? "",
                                 "appId":appId ?? "",
                                 "state":state  ?? 1]
        var models:[[String:String]] = []
        for mod:UnitOrgStoreModel in bindStoreList {
            let jj:[String:String] = ["bindId":mod.bindId,"companyName":mod.companyName]
            models.append(jj)
        }
        root["bindStoreList"] = models
        return root
    }
    
}

class UnitOrgStoreModel {
    var bindId:String!
    var companyName:String!
}
