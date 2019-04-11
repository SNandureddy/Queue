//
//  UserVM.swift
//  ScooterRental
//
//  Created by ios on 08/10/18.
//  Copyright © 2018 ios28. All rights reserved.
//

import Foundation
class UserVM {
    public static let shared = UserVM()
    private init() {}
    
    var userDetails: User!
    
    func signup(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.signup(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func login(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.login(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.parseLoginData(response: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func forgotPassword(email: String, response: @escaping responseCallBack) {
        APIManager.forgotPassword(email: email, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func getProfile(response: @escaping responseCallBack) {
        APIManager.getProfile(successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.parseLoginData(response: responseDict, isGet: true)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func updateProfile(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.updateProfile(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.parseLoginData(response: responseDict, isGet: true)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
}
