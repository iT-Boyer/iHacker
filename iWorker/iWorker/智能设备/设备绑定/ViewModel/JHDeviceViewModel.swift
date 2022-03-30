//
//  JHDeviceBaseVM.swift
//  iWorker
//
//  Created by boyer on 2022/3/30.
//

import Foundation

protocol JHModelBindableProtocol {
    associatedtype CellView
    func bind(view:CellView)
}

//Swift的组合运算符&支持将一个类和一个协议结合起来
typealias MBindable<CellView> = JHDeviceViewModel<CellView> & JHModelBindableProtocol
// 绑定SNView
class JHDeviceViewModel<CellView>: NSObject {
    
    var kvoToken: NSKeyValueObservation?
    
    deinit {
        kvoToken?.invalidate()
    }
}
