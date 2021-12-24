//
//  Landmark.swift
//  iHacker
//
//  Created by boyer on 2021/12/22.
//

import Foundation

struct LandmarkT: Hashable,Codable,Identifiable{
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    var isFavorite:Bool
    
    private var imageName: String
    
    private var coordinates:Coordinates
    
    struct Coordinates: Hashable, Codable{
        var latitude:Double
        var longitude:Double
    }
}
