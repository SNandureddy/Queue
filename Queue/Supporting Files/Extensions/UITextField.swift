//
//  UITextField.swift
//  Vits Video Calling Interpreter
//
//  Created by Apple on 07/08/17.
//  Copyright © 2017 Deftsoft. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    var isEmpty: Bool {
        return self.text?.trimmingCharacters(in: .whitespaces).count == 0 ? true: false
    }
    
    var count: Int {
        return self.text?.count ?? 0
    }
    
    func setPlaceholder(placholder: String? = nil, color: UIColor, size: CGFloat, style: UIFont.AppFont) {
        let myPlaceholder = placholder ?? self.placeholder!
        let attributedString = NSAttributedString(string: myPlaceholder, attributes:[NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: style.fontWithSize(size: size)])
        self.tintColor = color
        self.font = style.fontWithSize(size: size)
        self.attributedPlaceholder = attributedString
    }
    
    
//    MARK: Validations
    var isValidEmail: Bool {
        let emailRegEx = "[a-z0-9!#$%üäöß&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!üäöß#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text!.lowercased())
    }

    var isValidPassword: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 6 ? true: false
    }
    
    var isValidName: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 2 ?  true: false
    }
}
