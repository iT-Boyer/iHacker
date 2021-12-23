//
//  ModelData.swift
//  iHacker
//
//  Created by boyer on 2021/12/22.
//

import Foundation
import Combine
//ModelData: observable object 是数据的自定义对象，它可以从 SwiftUI 环境中的存储绑定到视图上
//ObservableObject 需要使用 @published 关键语句注明哪个属性为发布者，发布对其数据的任何更改，以便其订阅者可以获取其更改。
//这时，就可以回到LandmarkList视图，设置接收数据相关环境配置
// 第一步：声明存储器 @EnvironmentObject var modelData:ModelData
// 第二步：装载环境  ContentView().environmentObject(ModelData())
class ModelData: ObservableObject {
    
    @Published var landmarks:[Landmark] = loadT("landmarkData.json")
}

func loadT<T:Decodable>(_ filename:String) -> T
{
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else{
        fatalError("加载 \(filename)失败")
    }

    do{
        data = try Data(contentsOf: file)
    }catch{
        fatalError("加载\(filename)失败：\(error)")
    }

    do{
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }catch{
        fatalError("\(filename)解析失败：\(error)")
    }
}
