//
//  UserDataModel.swift
//  Queue
//
//  Created by IOS on 18/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import Foundation

struct User {
    var name: String!
    var email: String!
    
    init(dict: JSONDictionary) {
        name = dict[APIKeys.kFullName] as? String ?? kEmptyString
        email = dict[APIKeys.kEmail] as? String ?? kEmptyString
    }
}

extension UserVM {
    
    func parseLoginData(response: JSONDictionary, isGet: Bool = false) {
        if let data = response[APIKeys.kData] as? JSONDictionary {
            if isGet {
                userDetails = User(dict: data)
            }
            else {
                DataManager.accessToken = data[APIKeys.kAccessToken] as? String ?? kEmptyString
                DataManager.name = data[APIKeys.kFullName] as? String ?? kEmptyString
                DataManager.email = data[APIKeys.kEmail] as? String ?? kEmptyString
            }
        }
    }
    
}
