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
        it("pass twice") { expect(true).to(beTruthy()) }
    }
}
