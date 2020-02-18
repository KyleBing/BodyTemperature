//
//  ClockFace.swift
//  BodyTemparature
//
//  Created by Kyle on 2020/2/17.
//  Copyright © 2020 Cyan Maple. All rights reserved.
//

import UIKit

class ClockFace: UIView {
    
    let strokeWidth: CGFloat = 1


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = self.bounds.midX - strokeWidth
        
        let faceView = self.getFaceView(in: self.bounds)
        let hands = getHands(center: center, fullLength: radius + strokeWidth)
        
//        hands.hourView.layer.anchorPoint = CGPoint(x: 1, y: 1)
//        hands.hourView.layer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi * 0.5))
//        hands.hourView.layer.affineTransform()
        
        self.addSubview(faceView)
        self.addSubview(hands.hourView)
        self.addSubview(hands.miniteView)
        
        
        let outlinePath = UIBezierPath(rect: hands.hourView.layer.frame)
        UIColor.green.setStroke()
        outlinePath.stroke()
        

    }
    
    
    func getFaceView(in bounds: CGRect) -> UIView{
        let faceView = UIView(frame: bounds)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.midX - strokeWidth
        let path = UIBezierPath(arcCenter: center ,
                                radius: radius,
                                startAngle: 0,
                                endAngle: CGFloat.pi * 2,
                                clockwise: true)
        Colors.clockFace.setFill()
        Colors.clockBorder.setStroke()
        path.lineWidth = strokeWidth
        path.fill()
        path.stroke()
        faceView.layer.shadowPath = path.cgPath
        return faceView
    }
    
    
    
    
    func getHands(center: CGPoint, fullLength: CGFloat) -> (miniteView: UIView, hourView: UIView){
        let widthHand = fullLength / 10         // 指针宽度
        let lengthMinite = fullLength * 0.8     // 分针长度
        let lengthHour = fullLength * 0.6       // 时针长度
        
        // Minite Hand
        let rectMinite = CGRect(x: fullLength - widthHand / 2, y: fullLength - lengthMinite + widthHand / 2, width: widthHand, height: lengthMinite)
        let miniteView = UIView(frame: rectMinite)
        let pathMinite = UIBezierPath(roundedRect: rectMinite, cornerRadius: widthHand / 2)
        Colors.purple.setFill()
        pathMinite.fill()
        miniteView.layer.shadowPath = pathMinite.cgPath
        
        // Hour Hand
        let rectHour = CGRect(x: fullLength - widthHand / 2, y: fullLength - lengthHour + widthHand / 2, width: widthHand, height: lengthHour)
        let hourView = UIView(frame: rectHour)
        let pathHour = UIBezierPath(roundedRect: rectHour, cornerRadius: widthHand / 2)
        Colors.magenta.setFill()
        Colors.blue.setStroke()
        pathHour.fill()
        hourView.layer.shadowPath = pathHour.cgPath



        
        return (miniteView, hourView)
    }
    
    
    
    
    

}
