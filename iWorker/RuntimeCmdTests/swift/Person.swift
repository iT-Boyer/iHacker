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
/// 3. dy

public class Person: NSObject {
    
    @objc public var name:String = ""
    
    @objc func like(_ animal:String)->String {
        return "\(name) like \(animal)"
    }
}
