//
//  Apiservice+CinemaList.swift
//  Queue
//
//  Created by Deftsoft on 22/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import Foundation

enum CinemaList: APIService{
    
    case getCinemas(dict: JSONDictionary)
    case getCities
    
    var path: String{
        var path = ""
        switch self{
            
        case .getCinemas:
            path = BASE_URL1.appending("cinemas")
        case .getCities:
            path = BASE_URL1.appending("cities")
        }
        return path
    }
    
    var resource: Resource{
        var resource: Resource!
        let headers = ["X-Api-Key": "iuL43MyqpzcgLcIhzn3bNVAPVXcvtfxJ","Accept-Language":"en"]
        switch self{
        case let .getCinemas(dict):
            resource = Resource(method: .get, parameters: dict, headers: headers)
        case .getCities:
//            let locale: NSLocale = NSLocale.current as NSLocale
//            let country = locale.countryCode
            //TODO: To be update
            let dict = ["countries": "GB"]//country ?? "GB"]
            resource = Resource(method: .get, parameters: dict, headers: headers)
        }
        return resource
    }
}

// Method for WebServices

extension APIManager{
    
    class func getCinemas(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        CinemaList.getCinemas(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func getCities(successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        CinemaList.getCities.request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
}
