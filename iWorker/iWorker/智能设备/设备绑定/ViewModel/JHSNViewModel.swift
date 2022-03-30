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
    @objc dynamic var SNCode:String?
    // 绑定SN，监听TextField修改SN
    func bind(view:JHDeviceSNCell){
        if kvoToken == nil {
            kvoToken = view.observe(\.SNCode) { (cell, code) in
                self.SNCode = code.newValue ?? nil
            }
        }
    }
}
