//
//  LandmarkDetail.swift
//  iHacker
//
//  Created by boyer on 2021/12/22.
//

import SwiftUI
import MapKit

struct LandmarkDetail: View {
    var landmark:Landmark
    var body: some View {
        ScrollView {
            MapView(coordinate: landmark.locationCoordinate)
                .frame(height: 300, alignment: .top)
                .ignoresSafeArea()
            CircleImage(image: landmark.image)
                .offset(y: -120)
                .padding(.bottom,-120)
            
            VStack(alignment: .leading){
                Text(landmark.name)
                    .font(.title)
                HStack{
                    Text(landmark.park)
                    Spacer()
                    Text(landmark.state)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                Text("关于\(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
            }.padding()
            
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: ModelData().landmarks[3])
    }
}
