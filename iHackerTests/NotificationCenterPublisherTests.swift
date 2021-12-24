//
//  NotificationCenterPublisherTests.swift
//  iHacker
//
//  Created by boyer on 2021/12/24.
//  
//
import Foundation
import Quick
import Nimble
import XCTest
import Combine

extension Notification.Name {
    static let myExampleNotification = Notification.Name("an-example-notification")
}

//通知发布者操作符闭包无法调试的两种情况，解决办法：必须声明变量赋值才可以调试。
// 1. 使用变量 let examplePublisher 调用操作符 examplePublisher.map{}
// 2. 直接使用NotificationCenter.default.publisher().map{} 无法调试map

//移步问题
//方式1
//let expectation = XCTestExpectation(description: self.debugDescription)
//expectation.fulfill()
//self.wait(for: [expectation], timeout: 30.0)
//方式2
//let expectation = self.expectation(description: self.debugDescription)
//expectation.fulfill()
//self.waitForExpectations(timeout: 20)

class NotificationCenterPublisherTests: QuickSpec {
    override func spec() {

        describe("操作符的使用方法串讲") {
            let expectation = self.expectation(description: self.debugDescription)
            var data:Data!
            beforeEach {
                let filename = "landmarkData.json"
                let testBundle = Bundle(for: type(of: self))
                if let file = testBundle.url(forResource: filename, withExtension: nil)
                {
                    data = try! Data(contentsOf: file)
                }
            }
            
            //操作符 处理相关流数据
            it("map操作符使用") {
                //声明通知发布者
                let publisher = NotificationCenter.default.publisher(for: .myExampleNotification)
                    .map { notif -> Data in
                    let userInfo = notif.userInfo
                    return userInfo?[ "data"]  as! Data
                }.sink(receiveValue: { data in
                    print("数据\(data)")
                    expectation.fulfill()
                })
                //发送通知和负载对象
                let note = Notification(name: .myExampleNotification, userInfo: ["data":data as Any])
                NotificationCenter.default.post(note)
                // 异步等待
                self.waitForExpectations(timeout: 5)
            }
        }
    }
}
