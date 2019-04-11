//
//  String.swift
//  Lens App
//
//  Created by Apple on 13/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation


extension String {
    
    var amountValue: String {
        return "$\(self)"
    }
    
    var languageName: String {
        let locale  = Locale(identifier: "en") as NSLocale
        return locale.displayName(forKey: .identifier, value: self) ?? "English"
    }
    
}
