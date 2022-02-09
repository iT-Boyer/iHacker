//
//  ContentView.swift
//  iHacker
//
//  Created by boyer on 2021/12/17.
//

import SwiftUI
//import Landmarks
//import Wesplit
//import MyLibrary

struct ContentView: View {
    var body: some View {
        // TODO: 列表
        NavigationView{
            List{
                NavigationLink {
                    MyLibrary(image: Image.init("turtlerock", bundle: nil))
                       .offset(x: 0, y: -130)
                       .padding(.bottom, -130)
                } label: {
                    Text("MyLibrary")
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
