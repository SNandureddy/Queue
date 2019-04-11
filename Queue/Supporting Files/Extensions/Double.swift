//
//  Double.swift
//  Lens App
//
//  Created by Apple on 16/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    
//    func getString() -> String {
//        return String()
//    }
    
    var roundValue: Double {
        let multiplier = pow(10, Double(2)) //Upto 2 Decimals
        return Darwin.round(self * multiplier) / multiplier
    }
}
