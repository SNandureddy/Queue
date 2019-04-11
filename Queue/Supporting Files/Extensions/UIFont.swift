//
//  UIFont
//
//
//  Created by Manish on 07/07/16.
//  Copyright © 2016 Manish. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
  
  enum AppFont: String {
    case regular = "Montserrat-Regular"
    case medium = "Montserrat-Medium"
    case bold = "Montserrat-Bold"
    
    func fontWithSize(size: CGFloat) -> UIFont {
      return UIFont(name: rawValue, size: size)!
    }
  }
}
