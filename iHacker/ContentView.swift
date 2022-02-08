//
//  ContentView.swift
//  iHacker
//
//  Created by boyer on 2021/12/17.
//

import SwiftUI
import Landmarks
import Wesplit

struct ContentView: View {
    var body: some View {
        // TODO: 列表
        NavigationView{
            List{
                NavigationLink {
                    Landmarks()
                } label: {
                    Text("官方案例")
                }
                
                NavigationLink {
                    Wesplit()
                } label: {
                    Text("Websplit")
                }


            }.navigationTitle("hack100天")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
