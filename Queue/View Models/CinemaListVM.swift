//
//  CinemaListVM.swift
//  Queue
//
//  Created by Deftsoft on 22/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import Foundation

class CinemaListVM {
    
    public static let shared = CinemaListVM()
    private init(){}
    
    var cinemasArray = [CinemaData]()
    var cityArray = [CityDetails]()
    
    func callApiToSearchCinema(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.getCinemas(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.paseCinemaListData(response: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func getCities(response: @escaping responseCallBack) {
        APIManager.getCities(successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.parseCityList(response: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
}
