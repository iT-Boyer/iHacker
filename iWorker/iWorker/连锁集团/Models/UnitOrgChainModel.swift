//
//  UnitOrgChainModel.swift
//  iWorker
//
//  Created by boyer on 2022/1/10.
//

import UIKit

class UnitOrgChainModel: NSObject {
    var account:String?
    var storeId:String?
    var appId:String?
    var bindStoreList:[UnitOrgStoreModel]?
    var state:Int?
    
    class UnitOrgStoreModel: NSObject {
        var bindId:String?
        var companyName:String?
    }
}
