//
//  Second.swift
//  SwiftLibB
//
//  Created by boyer on 2021/12/30.
//

import Foundation

public class SecondB: NSObject {
    
    @objc public class func shared() -> SecondB {
        return SecondB()
    }
}
