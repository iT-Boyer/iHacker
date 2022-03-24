//
//  StringSepcs.swift
//  iWorkerTests
//
//  Created by boyer on 2022/3/3.
//

import Foundation
import Quick
import Nimble
@testable import iWorker

class StringSepcs: QuickSpec {
    
    override func spec() {
        xdescribe("判断合法") {
            it("特定字符串") {
                let code = JHDeviceInviteAPI.isValid("http://www.baidu.com?invitecode=1332")
                expect(code).toEventually(beTruthy())
            }
            it("16位数字") {
                let valid = JHDeviceInviteAPI.isValid("878687868868786")
                expect(valid).to(equal(true))
            }
        }
        
        describe("时间戳") {
            it("获取当前时间") {
                let date = Date.now
                //设置为24小时制
                let locale = Locale(identifier: "en_GB")
                print("\(date)")
            }
        }
    }
}
