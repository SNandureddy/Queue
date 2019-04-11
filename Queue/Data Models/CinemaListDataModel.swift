//
//  CinemaListDataModel.swift
//  Queue
//
//  Created by Deftsoft on 22/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import Foundation

struct CityDetails {
    var name: String?
    var id: String?
    
    init(details: JSONDictionary) {
        self.name = details[APIKeys.kName] as? String
        self.id = details[APIKeys.kCityIds] as? String
    }
}

struct CinemaData{
    
    var cinemaId: String?
    var cinemaName: String?
    var cinemaChainId: String?
    var cinemaTelephone: String?
    var cinemaWebsite: String?
    var cinemaLatitude: Double?
    var cinemaLongitude: Double?
    var displayText: String?
    var cinemaStreet: String?
    var cinemaCountry: String?
    var zipCode: String?
    
    init(details: JSONDictionary) {
        self.cinemaId = details[APIKeys.kID] as? String
        self.cinemaName = details[APIKeys.kCinemaName] as? String
        self.cinemaChainId = details[APIKeys.kCinemaChainId] as? String
        self.cinemaTelephone = details[APIKeys.kCinemaTelephone] as? String
        self.cinemaWebsite = details[APIKeys.kCinemaWebsite] as? String
        if let cinemaLocation = details[APIKeys.kCinemaLocation] as? JSONDictionary{
            self.cinemaLatitude = cinemaLocation[APIKeys.kCinemaLatitude] as? Double
            self.cinemaLongitude = cinemaLocation[APIKeys.kCinemaLongitude] as? Double
              if let address = cinemaLocation[APIKeys.kCinemaAddress] as? JSONDictionary{
                self.displayText = address[APIKeys.kCinemaDisplayText] as? String
                self.cinemaCountry = address[APIKeys.kCinemaCountry] as? String
                self.cinemaStreet = address[APIKeys.kCinemaStreet] as? String
                self.zipCode = address[APIKeys.kCinemaZipCode] as? String
            }
        }
    }
}

//Mark: ParsingData
extension CinemaListVM {
    
    func paseCinemaListData(response: JSONDictionary){
        if let cinemaData = response[APIKeys.kCinemaList] as? JSONArray{
            self.cinemasArray.removeAll()
            for cinema in cinemaData{
                let cinemadetails = CinemaData(details: cinema)
                cinemasArray.append(cinemadetails)
            }
        }
    }
    
    func parseCityList(response: JSONDictionary) {
        if let cityArray = response[APIKeys.kCities] as? JSONArray {
            for city in cityArray {
                let data = CityDetails(details: city)
                self.cityArray.append(data)
            }
        }
    }
}
