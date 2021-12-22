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
                    LandmarkDetail()
                } label: {
                    LandmarkRow(landmark:landmark)
                }
            }
        }
        .navigationTitle("Landmarks")
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
    }
}
