//
//  AppModules.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//

import Foundation
import Viperit

enum AppModules: String, ViperitModule, CaseIterable {
    case Index //Viper 相关demo入口页面
    case TODO  //练习模块
    case Reform //自查模块
    
    var viewType: ViperitViewType {
        switch self {
            default: return .code
        }
    }
}
