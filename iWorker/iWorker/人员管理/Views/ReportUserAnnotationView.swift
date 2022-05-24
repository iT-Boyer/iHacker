//
//  ReportUserAnnotationView.swift
//  iWorker
//
//  Created by boyer on 2022/5/24.
//

import MapKit

class ReportUserAnnotation:NSObject,MKAnnotation {
    var userId:String?
    var icon:String?
    
    var title: String?
    var subtitle: String?
    var coordinate = CLLocationCoordinate2D()
    
}


class ReportUserAnnotationView: MKAnnotationView {
    /// 重写初始化大头针控件方法
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        // 显示自定义大头针的标题和子标题
        canShowCallout = false
        // 设置自定义大头针的子菜单左边显示一个图片
        leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重写大头针模型的 setter 方法
    var model:ReportUserAnnotation?{
        didSet{
            // 设置自定义大头针图片
            image = UIImage(named: model?.icon ?? "")
            // 设置自定义大头针的子菜单图片
            leftCalloutAccessoryView?.largeContentImage = image
        }
    }
    
    
}
