//
//  LandmarkRow.swift
//  iHacker
//
//  Created by boyer on 2021/12/22.
//

import SwiftUI

struct LandmarkRow:View
{
    var landmark:Landmark

    var body: some View{
        HStack{
            landmark.image
              .resizable()
              .frame(width:50, height:50)
            Text(landmark.name)
            Spacer()
        }.padding()
    }
}

struct LandmarkRow_Previews:PreviewProvider
{
    // previews 可以返回多个View someview
    // previewLayout 预览视图布局方法。辅助在开发中的多个视图的布局样式。
    // Group容器，可以批量处理多个View的样式。
    static var previews:some View{
        
        LandmarkRow(landmark: landmarks[0])
            .previewLayout(.fixed(width: 390, height: 50))
        LandmarkRow(landmark: landmarks[1])
            .previewLayout(.fixed(width: 390, height: 50))
        
        //使用group分组，group的设置会作用到每一个View上
        Group{
            LandmarkRow(landmark: landmarks[2])
            LandmarkRow(landmark: landmarks[3])
        }.previewLayout(.fixed(width: 390, height: 50))
        
    }
}
