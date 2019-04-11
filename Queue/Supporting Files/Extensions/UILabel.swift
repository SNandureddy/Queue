//
//  UILabel.swift
//  HealthSplash
//
//  Created by Apple on 20/11/17.
//  Copyright © 2017 Deftsfot. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func spaceBetweenText(aligncenter: Bool = false, space: CGFloat = 5.0) {
        let attributedString = NSMutableAttributedString(string: self.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        if aligncenter {
            paragraphStyle.alignment = .center
        }
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString;
        
        
    }
}
