//
//  JNRequestTests.swift
//  iHacker
//
//  Created by boyer on 2021/12/21.
//  
//

import Quick
import Nimble
import JHBase
import OHHTTPStubs
import OHHTTPStubsSwift
import SwiftyJSON
@testable import JinheAPP
import XCTest

class JNRequestTests: QuickSpec {
    override func spec() {
        describe("访问接口解析") {
            // 模拟数据接口
            var inspecter:JHMornInspecterController!
            var expectation:XCTestExpectation!
            beforeEach {
                inspecter = JHMornInspecterController()
                inspecter.installOHHTTPStubs()
                expectation = self.expectation(description: "token认证")
            }
            
            xit("提交照片信息") {
                inspecter.submit()
            }
            
            fit("接口数据解析:SaveMorningCheckImg") {
                let urlStr = JHBaseDomain.fullURL(with: "api_host_ripx", path: "/api/MorningCheck/SaveMorningCheckImg")
                let request = JN.post(urlStr, parameters: [:])
                request.response { response in
                    //
                    let json = JSON(response.data!)
                    print(json)
                    //在异步方法被测试的相关的回调中实现那个期望值
                    expectation.fulfill()
                }
                self.waitForExpectations(timeout: 20, handler: { error in
                    //
                    print("错误信息:\(String(describing: error?.localizedDescription))")
                })
            }
        }
    }
}
