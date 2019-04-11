//
//  ApiService+User.swift
//  ScooterRental
//
//  Created by ios on 08/10/18.
//  Copyright © 2018 ios28. All rights reserved.
//

import Foundation


enum UserAPIServices: APIService {
    case signup(dict: JSONDictionary)
    case login(dict: JSONDictionary)
    case forgotPassword(email: String)
    case getProfile
    case updateProfile(dict: JSONDictionary)

    
    var path: String {
        var path = ""
        switch self {
        case .signup:
            path = BASE_URL.appending("register")
        case .login:
            path = BASE_URL.appending("login")
        case .forgotPassword:
            path = BASE_URL.appending("password/forgot")
        case .getProfile:
            path = BASE_URL.appending("profile")
        case .updateProfile:
            path = BASE_URL.appending("profile")
        }
        return path
    }
    
    var resource: Resource {
        var resource: Resource!
        let headers = ["Authorization": "Bearer \(DataManager.accessToken ?? "")"]
        switch self {
        case let .signup(dict):
            resource = Resource(method: .post, parameters: dict, headers: nil)
        case let .login(dict):
            resource = Resource(method: .post, parameters: dict, headers: nil)
        case let .forgotPassword(email):
            resource = Resource(method: .post, parameters: [APIKeys.kEmail:email], headers: nil)
        case .getProfile:
            resource = Resource(method: .get, parameters: nil, headers: headers)
        case let .updateProfile(dict):
            resource = Resource(method: .post, parameters: dict, headers: headers)
        }
        return resource
    }
    
}

// MARK: Method for webservice
extension APIManager {
    
    class func signup(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.signup(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func login(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.login(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func forgotPassword(email: String, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.forgotPassword(email: email).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func getProfile(successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.getProfile.request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func updateProfile(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        UserAPIServices.updateProfile(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
}
