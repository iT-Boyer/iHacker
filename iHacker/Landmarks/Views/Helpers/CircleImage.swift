//
//  CircleImage.swift
//  iHacker
//
//  Created by boyer on 2021/12/21.
//

import SwiftUI

/// 结构体属性，会自动添加到构造器参数中，新增属性时，需要更新实例化时的入参。
struct CircleImage: View {
    var image:Image
    var body: some View {
        image
            .frame(width:140,height: 150)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("turtlerock"))
    }
}
