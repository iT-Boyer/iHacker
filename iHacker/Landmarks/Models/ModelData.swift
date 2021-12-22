//
//  ModelData.swift
//  iHacker
//
//  Created by boyer on 2021/12/22.
//

import Foundation

var landmarks:[Landmark] = loadT("landmarkData.json")

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
