//
//  RuntimeTools.swift
//  RuntimeCmdTests
//
//  Created by boyer on 2021/12/30.
//

import Foundation

/// 单元测试工具箱
/// 1. 获取类的方法和属性清单
class Tools: NSObject {
    
    
    
    /// 获取类的方法和属性清单
    /// - Parameter type: class.self
    @objc static func methodAndProList(_ type:AnyClass) {
        
        var methodCount:UInt32 = 0
        //方法
        let methodlist = class_copyMethodList(type, &methodCount)
        for  i in 0..<numericCast(methodCount) {
            if let method = methodlist?[i]{
                let methodName = method_getName(method);
                print("方法列表：\(String(describing: methodName))")
            }else{
                print("not found method");
            }
        }
        
        // 属性
        var count:UInt32 = 0
        let proList = class_copyPropertyList(type, &count)
        for  i in 0..<numericCast(count) {
            if let property = proList?[i]{
                let propertyName = property_getName(property);
                print("属性列表：\(String(utf8String: propertyName)!)")
            }else{
                print("not found property");
            }
        }
    }
}
