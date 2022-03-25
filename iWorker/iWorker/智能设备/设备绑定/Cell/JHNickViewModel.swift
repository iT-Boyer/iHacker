//
//  JHDeviceViewModel.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//

import Foundation

class JHNickViewModel:NSObject {
    
    var kvoToken: NSKeyValueObservation?
    // 场景
    @objc dynamic var nick:String?
    
    func bindSN(_ sn:JHDeviceSNCell){
        kvoToken = sn.observe(\.SNCode) { (cell, code) in
            self.nick = ""
        }
    }
    
    deinit {
        kvoToken?.invalidate()
    }
    
}
