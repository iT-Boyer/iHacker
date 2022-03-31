//
//  JHSNViewModel.swift
//  iWorker
//
//  Created by boyer on 2022/3/30.
//

import Foundation

// 绑定SNView
class JHSNViewModel: MBindable<JHDeviceSNCell> {
    // SN号
    @objc dynamic var SNCode:String? // 用于场景+昵称监听
    @objc dynamic var value:String? //仅用于View监听
    // 绑定SN，监听TextField修改SN
    func bind(view:JHDeviceSNCell){
        if kvoToken == nil {
            kvoToken = view.observe(\.SNCode, options: [.new, .old]) { (cell, code) in
                self.SNCode = code.newValue ?? ""
            }
        }
    }
}
