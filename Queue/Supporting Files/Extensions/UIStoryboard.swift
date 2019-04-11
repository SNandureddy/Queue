//
//  UIStoryboard.swift
//  Legasi
//
//  Created by Apple on 07/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard : String {
    case main
    case settings
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard  {
    
    /// Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue.capitalized, bundle: bundle)
    }
    
    
}

