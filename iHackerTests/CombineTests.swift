//
//  CombineTests.swift
//  iHacker
//
//  Created by boyer on 2021/12/24.
//  
//

import Quick
import Nimble
import Combine

class CombineTests: QuickSpec {
    override func spec() {
        describe("管道流--过程测试") {
            
            it("使用基础Just发布者测试") {
                //
                Just(1).map { value -> String in
                    switch value {
                    case 1:
                        return "3"
                    default:
                        return "4"
                    }
                }.sink { reciveValue in
                    print("得到的结果：\(reciveValue)")
                }
            }
        }
    }
}
