//
//  RuntimeAPITests.swift
//  iWorker
//
//  Created by boyer on 2021/12/29.
//  
//
import Foundation
import Quick
import Nimble
import SwiftLibB

class RuntimeAPITests: QuickSpec {
    override func spec() {
        describe("SwiftLibB") {
            
            it("打印SwiftLibB的动态方法") {
                var methodCount:UInt32 = 0
                
                let cls = objc_getClass("SwiftLibB")
                //方法
                let methodlist = class_copyMethodList(SwiftLibB.self, &methodCount)
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
                let proList = class_copyPropertyList(SwiftLibB.self, &count)
                for  i in 0..<numericCast(count) {
                    if let property = proList?[i]{
                        let propertyName = property_getName(property);
                        print("属性列表：\(String(utf8String: propertyName)!)")
                    }else{
                        print("not found property");
                    }
                }
                
                print("test run")
            }
        }
    }
}
