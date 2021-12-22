//
//  LandmarkDetail.swift
//  iHacker
//
//  Created by boyer on 2021/12/22.
//

import SwiftUI

struct LandmarkDetail: View {
    var body: some View {
        VStack {
            
            MapView()
                .frame(height: 200, alignment: .top)
                .ignoresSafeArea()
            CircleView()
                .offset(y: -100)
                .padding(.bottom,-100)
            
            VStack(alignment: .leading){
                Text("张三家")
                    .font(.title)
                Divider()
                HStack{
                    Text("二拨子新村")
                        .font(.title2)
                    Spacer()
                    Text("回龙观")
                        .font(.title2)
                }.foregroundColor(.gray)
                Divider()
              Spacer()
                Text("关于")
                    .font(.title2)
                Text("学习开发技巧")
            }.padding()
            Spacer()
        }
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail()
    }
}
