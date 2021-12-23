//
//  CircleView.swift
//  iHacker
//
//  Created by boyer on 2021/12/21.
//

import SwiftUI

struct CircleView: View {
    var body: some View {
        ZStack {
            Circle().frame(width: 200, height: 200, alignment: .bottom)
                .foregroundColor(.purple)
                .overlay(Circle().stroke(.gray, lineWidth: 4))
                .shadow(radius: 10)
            Text("头像").foregroundColor(.white).background(.black)
        }
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}
