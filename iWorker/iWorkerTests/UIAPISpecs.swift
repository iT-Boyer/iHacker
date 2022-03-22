//
//  UIAPISpecs.swift
//  iWorker
//
//  Created by boyer on 2022/3/22.
//  
//
import UIKit
import Quick
import Nimble
@testable import iWorker

class UIAPISpecs: QuickSpec {
    override func spec() {
        
        describe("读取控件和方法属性") {
            
            it("UIAlertAction属性") {
                Tools.showClsRuntime(cls: UIAlertAction.self)
            }
        }
    }
}
