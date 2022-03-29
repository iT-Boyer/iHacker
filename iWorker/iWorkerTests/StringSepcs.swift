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
        describe("判断合法") {
            xit("特定字符串") {
                let code = JHDeviceInviteAPI.isValid("http://www.baidu.com?invitecode=1332")
                expect(code).toEventually(beTruthy())
            }
            it("15位数字") {
                let valid = JHDeviceInviteAPI.isValid("878687868868786")
                expect(valid).to(equal(true))
            }
            it("12位数字") {
                let valid = JHDeviceInviteAPI.isValid("878687868868")
                expect(valid).to(equal(true))
            }
            it("13位数字") {
                let valid = JHDeviceInviteAPI.isValid("8786878688687")
                expect(valid).to(equal(true))
            }
        }
        
        xdescribe("时间戳") {
            it("获取当前时间") {
                let date = Date.now
                //设置为24小时制
                let locale = Locale(identifier: "en_GB")
                print("\(date)")
            }
        }
    }
}
