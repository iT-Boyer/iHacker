//
//  AppModules.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//

import Foundation
import Viperit
// 枚举成员用例 关联值 原始值 构造器 方法
enum AppModules: String, ViperitModule, CaseIterable {
    case Index //Viper 相关demo入口页面
    case TODO //练习模块
    case Reform //自查模块
    
    var viewType: ViperitViewType {
        switch self {
            default: return .code
        }
    }
    
    var title: String {
        switch self {
        case .Index: return "ViperIt"
        case .TODO: return "TODO清单工具"
        case .Reform: return "自改自查"
        }
    }
}
