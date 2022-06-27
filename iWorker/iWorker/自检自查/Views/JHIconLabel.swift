//
//  CheckIconLabel.swift
//  iWorker
//
//  Created by boyer on 2022/6/27.
//

import UIKit

class JHIconLabel: UILabel {

    convenience init(icon: String, text:String = "") {
        self.init(frame:CGRect.zero)
        refresh(icon: icon, text: text)
    }
    
    func refresh(icon:String, text:String){
        let attribute = NSMutableAttributedString(string: text)
        let markattch = NSTextAttachment() //定义一个attachment
        markattch.image = UIImage(named: icon)//初始化图片
        markattch.bounds = CGRect(x: 0, y: -1, width: 13, height: 13) //初始化图片的 bounds
        let markattchStr = NSAttributedString(attachment: markattch) // 将attachment  加入富文本中
        attribute.insert(markattchStr, at: 0)// 将markattchStr  加入原有文字的某个位置
        
        attributedText = attribute
    }
}

class JHLineImageView: UIImageView {
    
    func refresh(isHorizontal:Bool,lineColor:UIColor) {
        
        UIGraphicsBeginImageContext(frame.size) // 位图上下文绘制区域
        image?.draw(in: bounds)
        
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
            context.addLine(to: CGPoint(x: bounds.size.width, y: 1))
        }else{
            context.addLine(to: CGPoint(x: 1, y: bounds.size.height))
        }
        context.strokePath()
        
        let line = UIGraphicsGetImageFromCurrentImageContext()
        image = line
    }
}

class JHSquareView: UIView {
    
    func drawDottedLine(_ rect: CGRect, _ radius: CGFloat, _ color: UIColor) {
        let boderLayer = CAShapeLayer()
        boderLayer.bounds = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        boderLayer.position = CGPoint(x: rect.midX, y: rect.midY)
        boderLayer.path = UIBezierPath(rect: layer.bounds).cgPath
        boderLayer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: radius).cgPath
        boderLayer.lineWidth = 1/UIScreen.main.scale
        //虚线边框
        boderLayer.lineDashPattern = [NSNumber(value: 5), NSNumber(value: 5)]
        boderLayer.fillColor = UIColor.clear.cgColor
        boderLayer.strokeColor = color.cgColor
        
        layer.addSublayer(boderLayer)
    }
}
