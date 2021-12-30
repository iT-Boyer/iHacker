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

class RuntimeCmdSpec: QuickSpec {
    override func spec() {
        describe("混编") {
            it("swift调用objc") {
                //1. 桥接文件
                //2. 添加import头文件
                let dog = Dog()
                let call = dog.call()
                expect(call).to(equal("旺旺2"))
            }
        }
        
        describe("Env环境runtime方法") {
            xit("读取类的方法和属性") {
                Tools.methodAndProList(Person.self)
            }
            it("读取class") {
//                let lib = SwiftLibB()
//                let cls = objc_getClass("SwiftLibB")
//                ((id(*)(id, Selector))objc_msgSend)(cls, Selector(""))
//                print("\(cls)")
            }
        }
    }
}
