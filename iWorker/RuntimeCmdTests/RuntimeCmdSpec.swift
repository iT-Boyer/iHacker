//
//  RuntimeCmdSpec.swift
//  iWorker
//
//  Created by boyer on 2021/12/29.
//  
//

import Quick
import Nimble
import SwiftLibB
import Foundation

class RuntimeCmdSpec: QuickSpec {
    override func spec() {
        xdescribe("混编") {
            it("swift桥接头调用objc") {
                //1. 桥接文件
                //2. 添加import头文件
                let dog = Dog()
                let call = dog.call()
                expect(call).to(equal("旺旺s"))
            }
        }
        
        xdescribe("swift使用runtime") {
            xit("读取类的方法和属性") {
                Tools.showClsRuntime(cls:Person.self)
            }
            
            xit("swift使用runtime调用OC") {
                //1. 获取类
                let cls:AnyClass = objc_getClass("Dog") as! AnyClass
                // 2. 创建对象
                let obj:NSObject = class_createInstance(cls,0) as! NSObject
                // 3. 初始化实例方法
//                    1. 当Dog.h不作桥接时，sel = Selector(("call"))
                //    2. 当Dog.h在桥接中时，sel = #selector(Dog.call)
                let sel = #selector(Dog.call)
                // 该方法无效
                let clsmethod = class_respondsToSelector(cls, sel)
                // 4. 判断实例是否支持实例方法
                if obj.responds(to: sel) {
                    // 5. 调用实例方法，拿到返回值
                    let result:String = obj.perform(sel).retain().takeRetainedValue() as! String
                    expect(result).to(equal("旺旺a"))
                }
            }
            
            it("类方法调用") {
                let cls:AnyClass = objc_getClass("Dog") as! AnyClass
                let sel = #selector(Dog.callCls) //Dog.callCls
                if let myClass = cls as? NSObjectProtocol {
                    let result = myClass.perform(sel).retain().takeUnretainedValue()//takeRetainedValue()
                    print(result)
                }
            }
            
            // AnyClass 替换为 NSObject.Type 获取Class即可
            it("OC构造器问题:class_createInstance不执行") {
                //1. 获取类
//                let cls:AnyClass = objc_getClass("Dog") as! AnyClass
                let cls:NSObject.Type = objc_getClass("Dog") as! NSObject.Type
                // 2. 创建对象
//                let obj:NSObject = class_createInstance(cls,0) as! NSObject
                let obj = cls.init()
                //let name = Selector(("name"))
                let name = #selector(getter: Dog.name)
                // 4. 判断实例是否支持实例方法
                if obj.responds(to: name) {
                    // 5. 调用实例方法，拿到返回值
                    let result:String? = obj.perform(name).retain().takeRetainedValue() as? String
                    expect(result).to(equal("哈士奇"))
                }
            }
        }
    }
}
