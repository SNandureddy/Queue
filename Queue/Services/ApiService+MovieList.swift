//
//  File.swift
//  Queue
//
//  Created by Deftsoft on 20/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.

import Foundation

enum MoviesList: APIService{
    
    case movies(dict: JSONDictionary)
    case showtimes(dict: JSONDictionary)
    
    var path: String{
        var path = ""
        switch self{
            
        case .movies:
            path = BASE_URL1.appending("movies")
        case .showtimes:
            path = BASE_URL1.appending("showtimes")
        }
        return path
    }
    
    var resource: Resource{
        var resource: Resource!
        let headers = ["X-Api-Key": "iuL43MyqpzcgLcIhzn3bNVAPVXcvtfxJ","Accept-Language":"en"]
        switch self{
        case let .movies(dict):
            resource = Resource(method: .get, parameters: dict, headers: headers)
        case let .showtimes(dict):
            resource = Resource(method: .get, parameters: dict, headers: headers)
        }
        return resource
    }
}
// Method for WebServices

extension APIManager{
    
    class func getMovieList(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        MoviesList.movies(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func getShowtimes(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback){
        MoviesList.showtimes(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary{
                successCallback(responseDict)
            }else{
                successCallback([:])
            }
        }, failure: failureCallback)
    }
}

