//
//  RuntimeCmdSpec.swift
//  iWorker
//
//  Created by boyer on 2021/12/29.
//  
//

import Quick
import Nimble

class RuntimeCmdSpec: QuickSpec {
    override func spec() {
        describe("混编") {
            it("swift调用objc") {
                //1. 桥接文件
                //2. 添加import头文件
                let dog = Dog()
                let call = dog.call()
                expect(call).to(equal("旺旺"))
            }
            it("objc调用swift") {
                // 不能在oc中引用-Swift.h文件，出现无法找到Dog类的情况。
                let dog = Dog()
                let owner = dog.owner()
                expect(owner).to(equal("张三"))
            }
        }
    }
}
