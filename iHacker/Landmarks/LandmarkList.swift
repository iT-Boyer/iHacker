//
//  Landmarks.swift
//  iHacker
//
//  Created by boyer on 2021/12/21.
//

import SwiftUI
import MapKit

struct LandmarkList: View {
    
    var body: some View {
        NavigationView{
            List(landmarks){ landmark in
                NavigationLink{
                    LandmarkDetail(landmark: landmark)
                } label: {
                    LandmarkRow(landmark:landmark)
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        
        return LandmarkList()
        //ForEach 以与 list 相同的方式对集合进行操作,这样我们就可以在任何可以使用子视图的地方使用它，比如 stacks ， lists ，groups 等。
        //当数据元素像这里使用的字符串一样是简单的值类型时，我们可以使用 \.self 作为标识符的 key path 。
        ForEach(["iPhone 13 Pro Max", "iPhone 13 Pro"], id: \.self) { deviceName in
                    LandmarkList()
                        .previewDevice(PreviewDevice(rawValue: deviceName))
                        .previewDisplayName(deviceName)
                }
    }
}
