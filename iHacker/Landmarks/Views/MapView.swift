//
//  MapView.swift
//  iHacker
//
//  Created by boyer on 2021/12/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    // 添加2D位置坐标属性
    var coordinate:CLLocationCoordinate2D
    // 地图显示的区域属性
    @State private var region = MKCoordinateRegion()
    
    // 视图onAppear周期方法修饰器,更新region区域，触发更新Map视图
    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
            setRegion()
        }
    }
    
    //setter方法
    func setRegion(){
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        region = MKCoordinateRegion(center: coordinate, span: span)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let coordinate = CLLocationCoordinate2DMake(34.011_286, -116.166_868)
        MapView(coordinate: coordinate)
    }
}
