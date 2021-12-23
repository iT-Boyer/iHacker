//
//  iHackerApp.swift
//  iHacker
//
//  Created by boyer on 2021/12/17.
//

import SwiftUI

@main
struct iHackerApp: App {
    @StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(modelData)
        }
    }
}
