//
//  SwiftConfig.swift
//  JinheAPP
//
//  Created by boyer on 2021/12/29.
//

import Foundation

// 在纯oc项目中创建一个空的swift文件，激活混编模式
 
public class SwiftConfig: NSObject {
    
    @objc dynamic public func testRuntimeT() {
        print(#function)
    }

}
