//
//  UIColor.swift
//  HealthSplash
//
//  Created by Apple on 16/11/17.
//  Copyright © 2017 Deftsfot. All rights reserved.
//

import Foundation
import UIKit

//extension UIColor {

    enum AppColor  {
        case navigationColor
        case baseColor
        case darkColor
        case menuTitleColor
        case greenColor
        case redColor
        case pinkColor
        
        func color(alpha: CGFloat = 1.0) -> UIColor {
            var colorToReturn:UIColor?
            switch self {
            case .navigationColor:
                colorToReturn = UIColor(red: 173/255, green: 28/255, blue: 61/255, alpha: alpha)
                
            case .baseColor:
                colorToReturn = UIColor(red: 208/255, green: 126/255, blue: 84/255, alpha: alpha)
                
            case .darkColor:
                colorToReturn = UIColor(red: 89/255, green: 89/255, blue: 89/255, alpha: alpha)
                
            case .menuTitleColor:
                colorToReturn = UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: alpha)
                
            case .greenColor:
                colorToReturn = UIColor(red: 139/255, green: 188/255, blue: 33/255, alpha: alpha)
                
            case .redColor:
                colorToReturn = UIColor(red: 255/255, green: 64/255, blue: 64/255, alpha: alpha)
                
            case .pinkColor:
                colorToReturn = UIColor(red: 166/255, green: 25/255, blue: 90/255, alpha: alpha)

            }
            return colorToReturn!
        }
        
        //TO REMOVE THE NAVIGATION BAR LINE
        //    func as1ptImage() -> UIImage {
        //        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        //        setFill()
        //        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        //        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        //        UIGraphicsEndImageContext()
        //        return image
        //    }
    }
    
//
//}



