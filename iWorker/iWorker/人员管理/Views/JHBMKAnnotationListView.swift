//
//  JHBMKAnnotationListView.swift
//  iWorker
//
//  Created by boyer on 2022/6/2.
//

import UIKit
import MapKit

class JHPersonalAnnocation:NSObject,MKAnnotation {

    var imageName = ""
    
    var title: String? = ""
    var subtitle: String? = ""
    var coordinate = CLLocationCoordinate2D()
    
}

class JHBMKAnnotationListView: MKAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var imageView = UIImageView()
    var model:JHPersonalAnnocation?{
        didSet{
            guard let mm = model else { return }
            image = .init(named: mm.imageName)
            imageView.image = image
        }
    }
}
