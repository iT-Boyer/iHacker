//
//  QuickTests.swift
//  iHacker
//
//  Created by boyer on 2021/12/22.
//  
//
import Foundation
import Quick
import Nimble
@testable import iHacker

class QuickTests: QuickSpec {
    override func spec() {
        describe("文件加载方式验证") {
            fit("加载app中的json文件") {
                let json:[Landmark] = loadT("landmarkData.json")
                print("json:\(json[0])")
            }
        }
    }
}
