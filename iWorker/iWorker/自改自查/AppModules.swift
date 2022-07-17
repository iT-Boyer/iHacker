//
//  AppModules.swift
//  iWorker
//
//  Created by boyer on 2022/7/17.
//

import Foundation
import Viperit

enum AppModules: String, ViperitModule {
    case Login
    case Home
    case Index
    case Camera
    
    var viewType: ViperitViewType {
        switch self {
        default: return .code
        }
    }
}
