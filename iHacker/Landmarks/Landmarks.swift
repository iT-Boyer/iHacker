//
//  Landmarks.swift
//  iHacker
//
//  Created by boyer on 2021/12/21.
//

import SwiftUI
import MapKit

struct Landmarks: View {
    
    @State public var location = MKCoordinateRegion(center: CLLocationCoordinate2DMake(10, 10), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            MapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            //头像
            CircleView()
                .offset(y: -130)
                .padding(.bottom,-100)
                .padding(.leading,100)
            
            VStack(alignment: .leading, spacing: 10) {
                //名称
                Text("金和").font(.title)
                
                HStack(){
                    Text("海淀区二拨子").font(.subheadline)
                    Spacer()
                    Text("北京")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Divider()
                Text("关于")
                    .font(.title2)
                Text("学习开发技巧")
            }
            .padding()
            Spacer()
        }
    }
}

struct Landmarks_Previews: PreviewProvider {
    static var previews: some View {
        Landmarks()
    }
}
