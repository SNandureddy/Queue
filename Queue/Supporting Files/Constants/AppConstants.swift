//
//  AppConstants.swift
//  Queue
//
//  Created by IOS on 18/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import Foundation
import UIKit

//*** MARK: BASE URL's ***
//let BASE_URL = "http://192.168.3.76/queue/api/v1/"
let BASE_URL = "http://dontqueue.co.uk/queue/api/v1/"
let BASE_URL1 = "https://api.internationalshowtimes.com/v4/"

//MARK: *** Transitions ***
var transition: CATransition {
    let transition = CATransition()
    transition.type = CATransitionType.fade
    transition.duration = 0.2
    return transition
}

let DISTANCE = 5

//*******COMMON**********

let kEmptyString = ""

//storyBoradName
let kMain = "Main"

//*** MARK: Class Identifiers ***
let kProfileVC = "ProfileVC"
let kTermConditionVC = "TermConditionVC"
let kTabBarVC = "TabBarVC"
let kSelectLocationVC = "SelectLocationVC"
let kChangePasswordVC = "ChangePasswordVC"
let kContactVC = "ContactVC"
let kSettingsVC = "SettingsVC"
let kShowTimingVC = "ShowTimingVC"
let kLoginVC = "LoginVC"
let kMoreVC = "MoreVC"

//*** MARK: Cell Identifiers ***
let kSettingCell = "SettingCell"
let kLoactionCell = "LoactionCell"
let kPlaceCell = "PlaceCell"
let kTimingDetailsCell = "TimingDetailsCell"
let kMoviesHeaderCell = "MoviesHeaderCell"
let kMoviesCell = "MoviesCell"
let kMovieCell = "MovieCell"
let kShowTimingCell = "ShowTimingCell"
let kSearchResultCell = "SearchResultCell"
let kFavouriteMoieCell = "FavouriteMoieCell"


//*** MARK: Titles ***
let kSettings = "Settings"
let kSelectLocation = "Select Your Location"
let kTermPolicyTitle = "Terms and Privacy Policy"
let kPrivacyPolicy = "Privacy Policy"
let kTermConditions = "Term and Conditions"
let kChangePassword = "Change Password"
let kContactUs = "Contact Us"
let kMoviewName = "Movie Name"
let kLogin = "Login"
let kMovies =  "Movies"
let kCinema = "Cinemas"

//*** MARK: Common ***
let kError = "Error"
let kSuccess = "Success"
let kOkay = "Okay"
let kUpdate = "Update"

//*** MARK: Data Managers ***
let kFirstTime = "kFirstTime"
let kAccessToken = "kAccessToken"
let kEmail = "kEmail"
let kName = "kName"
let kCountryCode = "CountryCode"
let kCountryName = "CountryName"
let kCityId = "kCityId"
let kLocation = "kLocation"



//*** MARK: Alerts ***
//Users
let kEmptyName = "Please enter your name."
let kValidName = "Name must be atleast 2 characters long."
let kEmptyEmail = "Please enter your email address."
let kValidEmail = "Please enter valid email address."
let kEmptyPassword = "Please enter password."
let kValidPassword = "Password must be atleast 6 characters long."
let kEmptyConfirmPassword = "Please enter confirm password."
let kValidConfirmPassword = "Password and confirm password does not match."
let kAcceptTerms = "Please accept terms and privacy policy."
let kLocationNotAVailable = "We are not available in your region."

//Common
let kErrorMessage = "Something went wrong."
let kAllMovies = "All Movies"
let kSorry = "Sorry"




//Array strings

let kLogoutString = "Log Out"
let kChnagePasswordString = "Change Password"

var menuArray = ["Change Location", "Contact Us", "Refer a Friend", "Discounts & Rewards", "Settings", "Log Out"]
var settingsArray = ["Privacy Policy", "Terms and Conditions", "Change Password" ]


// BaseVC
let kLocationMessage = "Please enable location access from settings."






















