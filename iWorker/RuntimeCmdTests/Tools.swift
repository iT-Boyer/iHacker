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
    @objc static func showClsRuntime (cls : AnyClass) {
        
        //获取类方法：https://www.jianshu.com/p/b30c2580d977
        print("start clsfunList")
        var clsmethodCount:UInt32 = 0
        let metacls: AnyClass? = object_getClass(cls)
        let clsfunList = class_copyMethodList(metacls, &clsmethodCount)
        for  i in 0..<numericCast(clsmethodCount) {
            if let method = clsfunList?[i]{
                let methodName = method_getName(method)
                print("类方法名：\(methodName)")
            }else{
                print("not found method");
            }
        }
        free(clsfunList)
        print("end clsfunList")
        
        
        print("start methodList")
        
        var methodCount:UInt32 = 0
        //方法
        let methodList = class_copyMethodList(cls, &methodCount)
        for  i in 0..<numericCast(methodCount) {
            if let method = methodList?[i]{
                let methodName = method_getName(method)
                let methodType = method_getTypeEncoding(method)
                let returnType = method_copyReturnType(method)
                print("方法名：\(String(describing: methodName))")
                print("方法类型：\(String(describing: methodType))")
                print("returnType：\(String(describing: returnType))")
            }else{
                print("not found method");
            }
        }
        free(methodList)
        print("end methodList")
        
        // 属性
        print("start proList")
        var count:UInt32 = 0
        let proList = class_copyPropertyList(cls, &count)
        for  i in 0..<numericCast(count) {
            if let property = proList?[i]{
                let propertyName = property_getName(property)
                let propertyAttributes = property_getAttributes(property)
                print("属性名：\(String(utf8String: propertyName)!)")
                print("属性：\(String(describing: propertyAttributes))")
            }else{
                print("not found property");
            }
        }
        free(proList)
        print("end proList")
    }

    ///Method Swizzeing runtime动态替换方法，必须有dynamic关键字
    func methodSwizze(cls : AnyClass,originalSelector : Selector , swizzeSelector : Selector)  {
        
        
        guard let originalMethod = class_getInstanceMethod(cls, originalSelector),
        let swizzeMethod = class_getInstanceMethod(cls, swizzeSelector) else {
            return
        }
        
        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzeMethod), method_getTypeEncoding(swizzeMethod))
        
        if didAddMethod {
            class_replaceMethod(cls, swizzeSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        }else {
            method_exchangeImplementations(originalMethod, swizzeMethod)
        }
        
    }
}
