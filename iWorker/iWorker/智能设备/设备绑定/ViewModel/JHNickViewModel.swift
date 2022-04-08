//
//  JHDeviceViewModel.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//

import Foundation

class JHNickViewModel:JHDeviceViewModel {//:MBindable<JHDeviceNickCell> {

    var snToken: NSKeyValueObservation?
    var scenceToken: NSKeyValueObservation?
    @objc dynamic var nick = "" //view 监听 Viewmodel ，例如：当切换场景时，重置nick
    /**
     value的两个作用
     1. 当手动编辑昵称时，更新ViewModel的nick值
     2. 避免监听冲突：例如：手动修改昵称时，会同步到value上。新增该字段，是因为如果共用nick字段，会造成两个监听冲突，循环监听。
     3. 为满足需求条件判断：当手动修改昵称之后，不同步场景名称。
     */
    var value = "" // viewModel 监听 view
    func bind(view:JHDeviceNickCell) {
        if kvoToken == nil {
            kvoToken = view.observe(\.nick, options: [.new, .old]) { (cell, nick) in
                let new = nick.newValue ?? ""
                print("编辑昵称：\(new ?? "")")
                self.value = new ?? ""
            }
        }
    }
    
    // 当修改SN号时，清空昵称
    func bindSN(_ sn:JHSNViewModel){
        if snToken == nil {
            snToken = sn.observe(\.SNCode) { (cell, code) in
                self.nick = ""
                self.value = ""
            }
        }
    }
    
    // 当切换场景时，更新昵称
    func bindScence(_ scence:JHSceneViewModel){
        if scenceToken == nil {
            scenceToken = scence.observe(\.sceneName, options: [.new, .old]) { (model, change) in
                guard let new = change.newValue else {
                    return
                }
                guard let old = change.oldValue else {
                    return
                }
                let scence = new ?? ""
                let oldname = old ?? ""
                let currnick = self.value
                print("场景切换时，更新\(currnick)昵称:\(scence)")
                if currnick == "" || currnick == oldname {
                    self.nick = scence
                    self.value = scence
                }
            }
        }
    }
    
    deinit {
        snToken?.invalidate()
        scenceToken?.invalidate()
    }
    
}
