//
//  SplitDotlineView.swift
//  iWorker
//
//  Created by boyer on 2022/5/31.
//

import Foundation
import UIKit

class SplitDotlineView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topView.image = imageline(imgView: topView, isHorizontal: false, lineColor: .k99A0B6)
        bottomView.image = imageline(imgView: bottomView, isHorizontal: false, lineColor: .k99A0B6)
    }
    
    func createView() {
        addSubviews([topView,dotView,bottomView])
        topView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.centerX.top.equalToSuperview()
        }
        dotView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 10, height: 10))
            make.top.equalTo(topView.snp.bottom)
        }
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(dotView.snp.bottom)
            make.width.equalTo(1)
            make.centerX.bottom.equalToSuperview()
        }
    }
    
    lazy var dotView: UIView = {
        let dot = UIView()
        dot.transform = CGAffineTransform(rotationAngle: 40)
        dot.layer.borderWidth = 1
        dot.layer.borderColor = UIColor.k99A0B6.cgColor
        return dot
    }()
    
    lazy var topView: UIImageView = {
        let imgview = UIImageView()
        return imgview
    }()
    
    lazy var bottomView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    func imageline(imgView:UIImageView,isHorizontal:Bool,lineColor:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContext(imgView.frame.size) // 位图上下文绘制区域
        imgView.image?.draw(in: imgView.bounds)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round) //CGLineCap.square
        
        let lengths:[CGFloat] = [4,3] // 绘制 跳过 无限循环
        //设置画笔颜色
        context.setStrokeColor(lineColor.cgColor)
//        context.setLineWidth(5)
        context.setLineDash(phase: 0, lengths: lengths)
        //设置虚线绘制起点
        context.move(to: CGPoint(x: 0, y: 1))
        //设置虚线绘制终点
        if isHorizontal {
            context.addLine(to: CGPoint(x: imgView.bounds.size.width, y: 1))
        }else{
            context.addLine(to: CGPoint(x: 1, y: imgView.bounds.size.height))
        }
        context.strokePath()
        
        let line = UIGraphicsGetImageFromCurrentImageContext()
        return line ?? UIImage()
    }
}
