//
//  DataManager.swift
//  Queue
//
//  Created by IOS on 18/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import Foundation
class DataManager {
    
    static var firstTime: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kFirstTime)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kFirstTime)
        }
    }
    
    static var accessToken: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kAccessToken)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kAccessToken)
        }
    }
    
    static var name: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kName)
        }
    }
    
    static var email: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kEmail)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kEmail)
        }
    }
    
    static var countryCode: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kCountryCode)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kCountryCode)
        }
    }
    
    static var countryName: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kCountryName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kCountryName)
        }
    }
    
    static var cityId: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kCityId)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kCityId)
        }
    }
        
    static var location: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kLocation)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kLocation)
        }
    }
    
//    static var ParisCountryLocation: String{
//        set{
//            UserDefaults.standard.set(newValue, forkey: kParisLocation)
//        }
//
//    }
    
    
}

// location of countries
//london
//lat =  51.509865
//long = -0.118092
//
//Paris
//lat = 48.864716
//long = 2.349014
//
//Singarpore
//lat = 1.290270
//long = 103.851959
//
//briminghaman
//lat = 52.479740
//long = -1.908484
//
//newyork
//lat = 40.730610
//long = -73.935242



