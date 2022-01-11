//
//  BaseAPISpec.swift
//  iWorker
//
//  Created by boyer on 2022/1/11.
//  
//
import Quick
import Nimble
import Foundation

class BaseAPISpec: QuickSpec {
    var stuss:[Student] = []
    
    override func spec() {
        _ = stuss.compactMap { stu in
            print("eee")
        }
        describe("验证筛选对象数组的方法") {
            var stus:[Student] = []
            beforeEach {
                let stu1 = Student(id: "1", name: "张三", age: 20)
                let stu2 = Student(id: "2", name: "李四", age: 22)
                let stu3 = Student(id: "3", name: "王二", age: 23)
                _ = self.stuss.compactMap { stu in
                    print(stu.name)
                }
                stus = [stu1,stu2,stu3]
            }
            
            it("使用map过滤") {
//                _ = stuss.compactMap{ sut in
//                    if sut.name == "张三" {
//                        return person
//                    }
//                    return nil
//                }
            }
            
            it("使用断言过滤") {
                
            }
            
            it("使用filter过滤") {
                let arr = stus.filter { stu in
                    stu.age == 22
                }
            }
        }
    }
}
