//
//  Colors.swift
//  BodyTemparature
//
//  Created by Kyle on 2020/2/17.
//  Copyright © 2020 Cyan Maple. All rights reserved.
//

import UIKit

struct Colors {
    static let purple = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
    static let magenta = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
    static let orange = UIColor(red: 255/255, green: 149/255, blue: 0, alpha: 1)
    static let blue = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
    static let clockBorder = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
    static let clockFace = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    
    static let lightGray = UIColor { (trait) -> UIColor in
        if trait.userInterfaceStyle == .light{
            return UIColor(red: 60/255, green: 60/255, blue: 76/255, alpha: 1)
        } else {
            return UIColor(red: 176/255, green: 176/255, blue: 176/255, alpha: 1)
        }
    }
}
