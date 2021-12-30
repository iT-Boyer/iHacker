//
//  SwiftRuntimeT.swift
//  SwiftLibB
//
//  Created by boyer on 2021/12/29.
//

import Foundation
/**
 1. 模拟oc调用swift的public方法（金和的井盖菜单逻辑）
 参考：https://runningyoung.github.io/2016/05/01/2016-05-01-Swift-Read2/
 */

@objc(SwiftRuntimeT)
public class SwiftRuntimeT: NSObject {

    //oc runtime调用swift方法
    //断言：dynamic 修饰之后，可以在objc_send方法中获取到
    @objc
    public func sharedT() {
        print("方法名："+#function)
    }
}
