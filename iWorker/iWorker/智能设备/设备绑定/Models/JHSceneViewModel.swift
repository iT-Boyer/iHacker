//
//  JHDeviceViewModel.swift
//  iWorker
//
//  Created by boyer on 2022/3/18.
//

import Foundation
// https://www.jianshu.com/p/8ab3f4ab344e
// https://www.jianshu.com/p/679820d645ad
class JHSceneViewModel:NSObject {
    // 场景
    @objc dynamic var sceneName:String?
    var sceneModel:JHSceneModel?
//    var kvoToken: NSKeyValueObservation?
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
//    deinit {
//        kvoToken?.invalidate()
//    }
    
}
