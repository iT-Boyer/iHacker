//
//  PhotoBaseVM.swift
//  iWorker
//
//  Created by boyer on 2022/6/9.
//

import Foundation

struct PhotoBaseVM {
    let Id,title,imgurl:String
    //图集个数
    let number:Int
    //支持多选的cell样式
    let addtype:Bool
    //选中状态
    let isadded:Bool
    let isHideDesc,isNeedEdit:Bool
    //false:菜品 true:环境
    let imgType:Bool
}
