//
//  FavoriteButton.swift
//  iHacker
//
//  Created by boyer on 2021/12/23.
//

import SwiftUI

/// 支持绑定存储器属性和状态属性的视图，便于更新状态。
struct FavoriteButton:View {
    @Binding var isSet:Bool
    
    var body: some View{
        
        Button {
            isSet.toggle()
        } label: {
            Label("点击收藏", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .yellow : .gray)
        }
    }
}

struct FavoriteButton_Previews:PreviewProvider {
    
    static var previews: some View{
        FavoriteButton(isSet: .constant(true))
    }
    
}
