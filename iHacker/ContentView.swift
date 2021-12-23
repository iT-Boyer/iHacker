//
//  ContentView.swift
//  iHacker
//
//  Created by boyer on 2021/12/17.
//

import SwiftUI
struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
