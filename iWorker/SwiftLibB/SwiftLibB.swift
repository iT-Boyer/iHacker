//
//  SwiftLibB.swift
//  SwiftLibB
//
//  Created by boyer on 2021/12/29.
//

/**
 1. 模拟oc调用swift的public方法（金和的井盖菜单逻辑）
 参考：https://runningyoung.github.io/2016/05/01/2016-05-01-Swift-Read2/
 */

import Foundation

@objc(SwiftLibB)
public class SwiftLibB:NSObject {

    //oc runtime调用swift方法
    //断言：dynamic 修饰之后，可以在objc_send方法中获取到
    @objc class public func shared() {
        print("文件名："+#file+"\n方法名："+#function+"\n行数：\(#line)")
    }
    @objc public func callMe(_ name:String) {
        print("请叫我：\(name)")
    }
}

extension SwiftLibB
{
    @objc public func callMeinEx(_ name:String) {
        print("Ex请叫我：\(name)")
    }
}
