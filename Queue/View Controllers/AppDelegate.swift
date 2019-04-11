//
//  AppDelegate.swift
//  Queue
//
//  Created by IOS on 12/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: Variables
    var window: UIWindow?

    //MARK: AppDelegate Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        enableKeyboard()
        DataManager.countryCode = NSLocale.current.regionCode
        DataManager.countryName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: NSLocale.current.regionCode ?? "in")
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 3.0))
        DataManager.firstTime ? navigateToHome(): navigateToTerms()
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        return true
    }
}


//MARK: Handle Libraries
extension AppDelegate {
    func enableKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    func navigateToTerms() {
        DataManager.firstTime = false
        let storyboard = UIStoryboard(storyboard: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: kTermConditionVC ) as! TermConditionVC
        let nav = UINavigationController(rootViewController: vc)
        if UIApplication.shared.keyWindow == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.layer.add(transition, forKey: kCATransition)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
            return
        }
        else {
            UIApplication.shared.keyWindow?.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController = nav
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
            return
        }
    }
    
    func navigateToHome() {
        BaseVC.locationName = DataManager.location!
        BaseVC.cityId = DataManager.cityId!
        let storyboard = UIStoryboard(storyboard: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: kTabBarVC ) as! TabBarVC
        let nav = UINavigationController(rootViewController: vc)
        if UIApplication.shared.keyWindow == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.layer.add(transition, forKey: kCATransition)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
            return
        }
        else {
            UIApplication.shared.keyWindow?.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController = nav
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
            return
        }
    }
}

//func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    let location = locations[0]
//    CLGeocoder().reverseGeocodeLocation(location) { (placeMark, error) in
//        if error != nil{
//            print("Some errors: \(String(describing: error?.localizedDescription))")
//        }else{
//            if let place = placeMark?[0]{
//                print("country: \(place.administrativeArea)")
//
//                //              self.lblCurrentLocation.text = place.administrativeArea
//            }
//        }
//    }
//}
