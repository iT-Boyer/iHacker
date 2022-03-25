//
//  JHDeviceViewModel.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//

import Foundation
// https://www.jianshu.com/p/8ab3f4ab344e
// https://www.jianshu.com/p/679820d645ad
//需求：
//1. 扫描自动填充，调用接口，上屏场景和昵称
//2. 在编辑时，重置场景和昵称

/*
//MVVM，vm的工作
1. 监听方：sn输入框是被监听方，VM绑定sn输入框状态
2. 被监听方：当SN变更时，重置场景和昵称
*/
class JHSceneViewModel:NSObject {
    // 场景
    var kvoToken: NSKeyValueObservation?
    
    @objc dynamic var sceneName:String?
    var sceneModel:JHSceneModel?{
        willSet{
            sceneName = newValue?.iotSceneName
        }
    }
    
    func bindSN(_ sn:JHDeviceSNCell){
        kvoToken = sn.observe(\.SNCode) { (cell, code) in
            self.sceneName = ""
        }
    }
    
//    
//    init() {
//        sceneModel = JHSceneModel()
//        bind()
//    }

//    func bind(){
//        kvoToken = sceneModel!.observe(\.iotSceneName, options: [.new, .old]) { (model, change) in
//            guard let name = change.newValue else { return }
//            self.sceneName = name
//        }
//    }
//
    deinit {
        kvoToken?.invalidate()
    }
    
}
