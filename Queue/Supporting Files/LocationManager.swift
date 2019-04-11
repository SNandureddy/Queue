//
//  LocationManager.swift
//  Reusable Class @ManishGumbal
//
//  Created by Manish Gumbal on 07/07/16.
//  Copyright © 2016 Manish Gumbal. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire


struct AddressDetails {
    var id: String!
    var address: String!
    var name: String!
    var lat : Double?
    var longi: Double?
}

typealias compleAddress = (([AddressDetails]) -> ())
typealias coordinates = ((CLLocationCoordinate2D)->())
typealias address = ((String) ->())
//possible errors
enum LocationManagerErrorReason: Int {
    case LocationDisabled
    case AuthorizationDenied
    case AuthorizationRestricted
    case AuthorizationNotDetermined
    case InvokeCallback
    case OtherReason
}

class LocationManager: NSObject {
    //location manager
    static let shared = LocationManager()
    var kGoogleMapApiKey = ""
    var locationManager: CLLocationManager?
    var needPlacemark = true
    var shouldInvokeCallback = false  {
        didSet {
            if shouldInvokeCallback {
                invokeLocationCallBack()
            }
        }
    }//To fix the iOS bug. iOS never gives call back if location permission is disabled and location permission is asked twice
    
    override private init() {
        //create the location manager
        locationManager = CLLocationManager()
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    typealias LocationManagerCallback = ((_ location: CLLocation?, _ placemark: CLPlacemark?, _ errorReason: LocationManagerErrorReason?)->())
    
    var didCompleteCallback: LocationManagerCallback?
    
    //location manager method called from delegate methods
    func locationManagerDidComplete(location: CLLocation?, placemark: CLPlacemark?, errorReason: LocationManagerErrorReason?) {
        locationManager?.stopUpdatingLocation()
        didCompleteCallback?(location, placemark, errorReason)
        locationManager?.delegate = nil
    }
    
    //ask for location permissions and fetch locations
    func askPermissionsAndFetchLocationWithCompletion(isPlacemarkRequired: Bool = true, shouldInvokePermissionFailureCallback: Bool = false, completionCallback: @escaping LocationManagerCallback) {
        //store the completion closure
        didCompleteCallback = completionCallback
        locationManager!.delegate = self
        needPlacemark = isPlacemarkRequired
        
        if isLoocationAccessEnabled() {
            locationManager?.startUpdatingLocation()
        }
        else {
            let mainBundle = Bundle.main
            if(mainBundle.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil) {
                locationManager?.requestWhenInUseAuthorization()
            } else if (mainBundle.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil) {
                locationManager?.requestAlwaysAuthorization()
            } else {
                debugPrint("To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
            }
            shouldInvokeCallback = shouldInvokePermissionFailureCallback
        }
    }
    
    func isLoocationAccessEnabled() -> Bool {
        var boolToReturn = false
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                boolToReturn = false
                Indicator.sharedInstance.hideIndicator()
            case .authorizedAlways, .authorizedWhenInUse:
                boolToReturn = true
            }
        } else {
            boolToReturn = false
        }
        return boolToReturn
    }
    
    func invokeLocationCallBack() {
        if shouldInvokeCallback {
            didCompleteCallback?(nil, nil, .InvokeCallback)
            shouldInvokeCallback = false
        }
    }
    
    func autoCompleteAddress(text: String!, complete: @escaping compleAddress) {
        let stringData: String!
        let languageCode = Locale.current.languageCode ?? "en"
        stringData = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" + text! + "&language=\(languageCode)&key=\(kGoogleMapApiKey)"
        let googleRequestURL = URL(string: stringData.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        if googleRequestURL != nil {
            DispatchQueue.main.async {
                var request = URLRequest(url: googleRequestURL!)
                request.httpMethod = "GET"
                let manager = Alamofire.SessionManager.default
                manager.session.configuration.timeoutIntervalForRequest = 120

                manager.request(request).responseJSON{ response in
                    DispatchQueue.main.async {
                        switch response.result {
                        case .success(let value):
                            self.fetchedData((value as? NSDictionary)!, complete: { (array) in
                                complete(array)
                            })
                        case .failure(_):
                            complete([AddressDetails]())
                        }
                    }
                }
            }
        }
        else {
            complete([AddressDetails]())
        }
    }
    
    func fetchedData(_ responseData: NSDictionary, complete: @escaping compleAddress) {
        var array = [AddressDetails]()
        let _: Error?
        do {
            let json = responseData
            if ((json["status"] as? String) == "OK") {
                let arrPrediction: NSArray = (json["predictions"] as? NSArray)!
                for item in arrPrediction {
                    let nameOfLocaiton = (item as? NSDictionary)?["description"] as? String
                    let name = ((item as? NSDictionary)?["structured_formatting"] as? NSDictionary)?["main_text"] as? String
                    let data = AddressDetails(id: "", address: nameOfLocaiton, name: name, lat: 0.0, longi: 0.0)
                    if nameOfLocaiton != nil {
                        array.append(data)
                    }
                }
                complete(array)
            }
            else {
                complete(array)
            }
        }
    }
    
    func getCoordinates(address: String!, completed: @escaping coordinates) {
        var coordinate = CLLocationCoordinate2D()
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            let placemark = placemarks?.first
            coordinate = placemark?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            completed(coordinate)
        }
    }
    
    func getAddress(location: CLLocationCoordinate2D, completion: @escaping address) {
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:location.latitude, longitude: location.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                else {
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        var addressString : String = ""
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.administrativeArea != nil {
                            addressString = addressString + pm.administrativeArea!
                        }
                        print(addressString)
                        completion(addressString)
                    }
                }
        })
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    // MARK: - CLLocation Delegate method implementation
    //location authorization status changed
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() {
            shouldInvokeCallback = false
            switch status {
            case .authorizedWhenInUse:
                self.locationManager!.startUpdatingLocation()
            case .restricted:
                locationManagerDidComplete(location: nil, placemark: nil, errorReason: .AuthorizationRestricted)
            case .denied:
                locationManagerDidComplete(location: nil, placemark: nil, errorReason: .AuthorizationDenied)
            case .notDetermined:
                locationManager!.requestWhenInUseAuthorization()
            default:
                break
            }
        }
        else {
            shouldInvokeCallback = true
            locationManager!.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        shouldInvokeCallback = false
        locationManagerDidComplete(location: nil, placemark: nil, errorReason: .OtherReason)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        shouldInvokeCallback = false
        if let location = locations[0] as CLLocation? {
            locationManager?.stopUpdatingLocation()
           locationManagerDidComplete(location: location, placemark: nil, errorReason: nil)
        }
        else {
            locationManagerDidComplete(location: nil, placemark: nil, errorReason: nil)
        }
    }
}

extension CLLocationCoordinate2D {
    
    var APIFormat: String {
        return "\(self.latitude),\(self.longitude)"
    }
}
