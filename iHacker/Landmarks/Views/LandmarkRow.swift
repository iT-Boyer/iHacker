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
            //icon
            landmark.image
              .resizable()
              .frame(width:50, height:50)
            //标题
            Text(landmark.name)
            Spacer()
            if landmark.isFavorite {
                //收藏, 需要安装 SF 符号库
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            
        }.padding()
    }
}

struct LandmarkRow_Previews:PreviewProvider
{
    static var landmarks = ModelData().landmarks
    // previews 可以返回多个View someview
    // previewLayout 预览视图布局方法。辅助在开发中的多个视图的布局样式。
    // Group容器，可以批量处理多个View的样式。
    static var previews:some View{
        /* 和Group分组效果等效
         LandmarkRow(landmark: landmarks[0])
             .previewLayout(.fixed(width: 390, height: 50))
         LandmarkRow(landmark: landmarks[1])
             .previewLayout(.fixed(width: 390, height: 50))
         
         */
        
        //使用group分组，group的设置会作用到每一个View上
        Group{
            LandmarkRow(landmark: landmarks[2])
            LandmarkRow(landmark: landmarks[3])
        }.previewLayout(.fixed(width: 390, height: 50))
        
    }
}
