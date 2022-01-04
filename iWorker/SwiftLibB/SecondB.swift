//
//  Second.swift
//  SwiftLibB
//
//  Created by boyer on 2021/12/30.
//

import Foundation

public class SecondB: NSObject {
    
    @objc public static let shareda = SecondB()
    @objc public class func shared() -> SecondB {
        return SecondB()
    }
    
    override init() {
        print("初始化："+#function)
    }
}
