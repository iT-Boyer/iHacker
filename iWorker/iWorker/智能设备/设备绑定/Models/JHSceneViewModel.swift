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
    dynamic var sceneName:String?
    var sceneModel:JHSceneModels?
    
    
    var kvoToken: NSKeyValueObservation?
    
    override init() {
        super.init()
        sceneModel = JHSceneModels(storeId: "", SN: "")
    }
    
    func observe(){
        //KeyPath<JHSceneModel, _>
        kvoToken = sceneModel!.observe(\.detail, options: [.old, .new]) { (model, change) in
            
        }
    }
    
    deinit {
        kvoToken?.invalidate()
    }
    
}
