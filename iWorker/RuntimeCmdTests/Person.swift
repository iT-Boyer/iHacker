//
//  Person.swift
//  RuntimeCmdTests
//
//  Created by boyer on 2021/12/29.
//

import Foundation

/// oc 调用
/// 1. public 权限
/// 2. @objc
/// 3. dynamic

class Person: NSObject {
    
    @objc var name:String = ""
    
    @objc class func shared() -> Person {
        return Person()
    }
    
    @objc dynamic func like(_ animal:String)->String {
        return "\(name) like \(animal)"
    }
}
