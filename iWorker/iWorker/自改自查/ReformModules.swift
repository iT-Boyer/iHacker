//
//  ReformModules.swift
//  iWorker
//
//  Created by boyer on 2022/7/19.
//

import Foundation
import Viperit

enum ReformModules:String, ViperitModule {
    case Reform
    case MyRecord
    case StoreRecord
    case Setting
    case Camera
    
    var viewType: ViperitViewType{
        switch self {
            default: return .code
        }
    }
}
