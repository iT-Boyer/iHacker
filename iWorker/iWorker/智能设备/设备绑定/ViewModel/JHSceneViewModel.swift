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
class JHSceneViewModel:JHDeviceViewModel{//:MBindable<JHDeviceSceneCell> {
    
    @objc dynamic var sceneName:String?
    var sceneModel:JHSceneModel?{
        didSet{
//            guard let model = newValue else{
//                sceneName = ""
//                return
//            }
            sceneName = sceneModel?.iotSceneName
        }
    }
    
    // 当变更场景时，暂时通过willSet属性观察器代替
    func bind(view:JHDeviceSceneCell){
        
    }
    
    // 当sn号修改时，重置场景
    func bindSN(_ SN:JHSNViewModel){
        if kvoToken == nil {
            kvoToken = SN.observe(\.SNCode) { (cell, code) in
                self.sceneModel = nil
            }
        }
    }
}
