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
        
        let hands = addMinuteHand(center: center, fullLength: self.bounds.midX)
        path.append(hands.handMinite)
        path.append(hands.handHour)
        
        let pathCenter = UIBezierPath(arcCenter: center, radius: 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        UIColor.black.setFill()
        pathCenter.fill()
        path.append(pathCenter)
    }
    
    
    
    func addMinuteHand(center: CGPoint, fullLength: CGFloat) -> (handMinite: UIBezierPath, handHour: UIBezierPath){
        let widthHand = fullLength / 10         // 指针宽度
        let lengthMinite = fullLength * 0.8     // 分针长度
        let lengthHour = fullLength * 0.6       // 时针长度
        
        // Minite Hand
        let rectMinite = CGRect(x: fullLength - widthHand / 2, y: fullLength - lengthMinite + widthHand / 2, width: widthHand, height: lengthMinite)
        let pathHandMinite = UIBezierPath(roundedRect: rectMinite, cornerRadius: widthHand / 2)
        Colors.purple.setFill()
        pathHandMinite.fill()
        
        // Hour Hand
        let rectHour = CGRect(x: fullLength - widthHand / 2, y: fullLength - lengthHour + widthHand / 2, width: widthHand, height: lengthHour)
        let pathHandHour = UIBezierPath(roundedRect: rectHour, cornerRadius: widthHand / 2)
        Colors.magenta.setFill()
        Colors.blue.setStroke()
        pathHandHour.stroke()

        
        pathHandHour.apply(CGAffineTransform(rotationAngle: CGFloat.pi * 0.02 ))
        pathHandHour.stroke()

        pathHandHour.apply(CGAffineTransform(rotationAngle: CGFloat.pi * 0.04 ))
        pathHandHour.stroke()

        pathHandHour.apply(CGAffineTransform(rotationAngle: CGFloat.pi * 0.06 ))
        pathHandHour.stroke()
        
        
        return (pathHandMinite, pathHandHour)
    }
    
    
    
    
    

}
