//
//  JHShapeView.swift
//  iWorker
//
//  Created by boyer on 2022/2/8.
//

import UIKit

class JHShapeView: UIView {
    
    var corners:UIRectCorner!
    var radii:CGSize!
    var fillColor:UIColor!
    
    init() {
        super.init(frame: CGRect.zero)
    }

    convenience init(corners:UIRectCorner,radii:CGSize,fillColor:UIColor) {
        self.init()
        self.corners = corners
        self.radii = radii
        self.fillColor = fillColor
        self.backgroundColor = fillColor
    }
    
    static func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: self.corners, cornerRadii: self.radii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.fillColor = fillColor.cgColor
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
