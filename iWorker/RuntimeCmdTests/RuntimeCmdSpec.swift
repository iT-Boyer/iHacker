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
                expect(call).to(equal("旺旺2"))
            }
        }
    }
}
