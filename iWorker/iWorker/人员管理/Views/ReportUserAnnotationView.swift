//
//  ReportUserAnnotationView.swift
//  iWorker
//
//  Created by boyer on 2022/5/24.
//

import MapKit

class ReportUserAnnotation:NSObject,MKAnnotation {
    var userId:String!
    
    var title: String? = ""
    var subtitle: String? = ""
    var coordinate = CLLocationCoordinate2D()
    
}


class ReportUserAnnotationView: MKAnnotationView {
    /// 重写初始化大头针控件方法
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        //显示气泡:自定义大头针的标题和子标题
        canShowCallout = false
        // 左边辅助视图:自定义大头针的子菜单左边显示一个图片
        let leftview = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        leftview.image = UIImage(systemName: "heart")
        leftCalloutAccessoryView = leftview
        image = UIImage(named: "mapusericon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
