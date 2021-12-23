//
//  Landmarks.swift
//  iHacker
//
//  Created by boyer on 2021/12/21.
//

import SwiftUI
import MapKit
import Combine
struct LandmarkList: View {
    //设置commbine环境
    @EnvironmentObject var modelData:ModelData
    
    // 仅展示收藏的row
    @State private var showFavoritesOnly = false
    // 筛选返回收藏的数据源
    var filterLandmarks:[Landmark]{
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView{
            // 列表中可以嵌套不同类型的视图：例如：Row和Toggle视图
            List{
                // 开关
                Toggle(isOn: $showFavoritesOnly) {
                    Text("仅看收藏")
                }.padding()
                
                // ForEach列表
                ForEach(filterLandmarks) { landmark in
                    
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        
        return LandmarkList()
                        .environmentObject(ModelData())
        
        
        //ForEach 以与 list 相同的方式对集合进行操作,这样我们就可以在任何可以使用子视图的地方使用它，比如 stacks ， lists ，groups 等。
        //当数据元素像这里使用的字符串一样是简单的值类型时，我们可以使用 \.self 作为标识符的 key path 。
        ForEach(["iPhone 13 Pro Max", "iPhone 13 Pro"], id: \.self) { deviceName in
                    LandmarkList()
                        .previewDevice(PreviewDevice(rawValue: deviceName))
                        .previewDisplayName(deviceName)
                }
    }
}
