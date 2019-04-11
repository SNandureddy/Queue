//
//  BaseVC.swift
//  Lens App
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import UserNotifications

enum DatePickerMode {
    case Date
    case Time
}
//MARK: *************  Base Protocols  ************

@objc protocol  BaseViewControllerDelegate {
    @objc optional func didSelectDatePicker(date: Date)
    @objc optional func didClickOnDoneButton()
}

class BaseVC: UIViewController {
    
     
//    @IBInspectable var imageForEmptyScreen:UIImage = #imageLiteral(resourceName: "placeholder") {
//         didSet {
//            emptyview.imageView.image = imageForEmptyScreen
//        }
//    }
//    @IBInspectable var titleForEmptyScreen:String = "" {
//        didSet {
//            emptyview.titleLabel.text = titleForEmptyScreen
//        }
//    }
//    @IBInspectable var descriptionForEmptyScreen:String = "" {
//        didSet {
//            emptyview.descriptionLabel.text = descriptionForEmptyScreen
//        }
//    }
//
  
    
    //lazy var emptyview:EmptyScreenView = EmptyScreenView(image: self.imageForEmptyScreen, title: self.titleForEmptyScreen, description: self.descriptionForEmptyScreen)
    static var cityId = String()
    static var locationName = String()

    var address = String()
    var datePickerView: UIDatePicker!
    var pickerDelegate: BaseViewControllerDelegate?
    var selectedDateTextField = UITextField()
    var pickerType: String!
    var tempDate = Date()
    //MARK: Side Menu Variables
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
//    static var userDetails = UserDetails(userDetails: JSONDictionary())
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("*** MEMORY WARNING ***")
    }
    
    func logout() {


        DataManager.accessToken = nil
//        DataManager.userDetails = nil
//        let center = UNUserNotificationCenter.current()
//        center.removeAllPendingNotificationRequests()
//        let storyboard = UIStoryboard(storyboard: .Main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        let navigationController = UINavigationController(rootViewController: vc)
//        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
    
}


//MARK: Location Handling
extension BaseVC {
    
    func getCurrentLocation(success: @escaping (Bool)->()) {
        Indicator.sharedInstance.showIndicator()
        LocationManager.shared.askPermissionsAndFetchLocationWithCompletion { (location, placemark, error) in

            if error != nil {
                Indicator.sharedInstance.hideIndicator()
                success(false)
                self.showAlert(message: kLocationMessage, {
                    self.openSettings()
                })
            }
            else {
                self.getAddress(coordinates: location!.coordinate,address: { (address) in
                    self.address = address
                    success(true)
                })
            }
        }
    }
    
    func getAddress(coordinates: CLLocationCoordinate2D, address: @escaping (String)->()) {
        LocationManager.shared.getAddress(location: coordinates) { (myAddress) in
            Indicator.sharedInstance.hideIndicator()
            address(myAddress)
        }
    }
}

//MARK: Navigation Methods
extension BaseVC {
    
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //Set Navigation Title
    func set(title:String, showBack: Bool = false, backImage: UIImage = #imageLiteral(resourceName: "Back_button"), showRight: Bool = false, rightImage: UIImage = #imageLiteral(resourceName: "Right_arrow")) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppColor.navigationColor.color()
        self.navigationController?.navigationBar.isTranslucent = false
        let titleButton = UIButton(frame: CGRect(x: 50, y:0, width:110, height:30))
        titleButton.titleLabel?.textAlignment = .center
        titleButton.setTitle(title, for: .normal)
        titleButton.isUserInteractionEnabled = false
        titleButton.titleEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 7, right: 0)
        titleButton.setTitleColor(UIColor.white, for: .normal)
        titleButton.titleLabel?.font = UIFont.AppFont.regular.fontWithSize(size: 20.0)
        self.navigationItem.titleView = titleButton
        if showBack {
            self.setBackButton(backImage: backImage)
        }
        else {
            self.navigationItem.hidesBackButton = true
        }
        if showRight {
            self.setRightBarButton(image: rightImage)
        }
        
    }
    
//    func setTitle(title:String, size: CGFloat? = 22) {
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2391761243, green: 0.2941474319, blue: 0.588160336, alpha: 1)
//        self.navigationController?.navigationBar.isTranslucent = false
//        let titleButton = UIButton(frame: CGRect(x: 50, y:0, width:110, height:30))
//        titleButton.titleLabel?.textAlignment = .center
//        titleButton.setTitle(title, for: .normal)
//        titleButton.setTitleColor(UIColor.white, for: .normal)
//        titleButton.titleLabel?.font = UIFont.CalculatorFont.regular.fontWithSize(size: size!)
//        titleButton.titleEdgeInsets = UIEdgeInsets(top: -7, left: 0, bottom: 7, right: 0)
//        self.navigationItem.titleView = titleButton
//    }
    
    //MARK: Back Button
    func setBackButton(backImage: UIImage){
        let backButton = UIButton()
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        backButton.setImage(backImage, for: UIControl.State.normal)
        backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControl.Event.touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK: right navigationButton
    func setRightBarButton(image: UIImage){
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        rightButton.setImage(image, for: UIControl.State.normal)
        rightButton.addTarget(self, action: #selector(self.rightBarButtonAction), for: UIControl.Event.touchUpInside)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightBarButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
    }
    
    @objc func backButtonAction() {
        self.view.endEditing(true)
        let backDone = self.navigationController?.popViewController(animated: true)
        if backDone == nil {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
 
    
    //MARK:- Move to next ViewController
    func moveToViewController(storyBoard: Storyboard, vcId: String){
        let storyboard = UIStoryboard(storyboard: storyBoard)
        let vc = storyboard.instantiateViewController(withIdentifier: vcId)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func goToHome(){
        let storyboard = UIStoryboard(storyboard: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: kTabBarVC) as! TabBarVC
        let navigationController = UINavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}

//MARK: Side Menu Methods
extension BaseVC {
    
    //MARK: Conversion Methods
    
    func convertDateFromString(date:String) -> (Date)  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        let s = dateFormatter.date(from: date)
        return s!
    }
    //MARK: *************   Set Date Picker   ***************
    
    func setDatePickerView(textField: UITextField, isCurrent: Bool,pickerMode:DatePickerMode? = nil) {
        
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = (pickerMode == .Date) ? .dateAndTime : .time
        datePickerView.locale = Locale(identifier: "en_US_POSIX")
        if pickerMode == nil {
            datePickerView.datePickerMode = .date
        }
        
        // datePickerView.maximumDate = Date()
        // let date = "01-01-1950".dateFromString(format: .dmyDate)
        if isCurrent == true{
            datePickerView.minimumDate = Date()
        }
        
        datePickerView.timeZone =  TimeZone.ReferenceType.default
        textField.inputView = datePickerView
        selectedDateTextField = textField
        datePickerView.addTarget(self, action: #selector(self.didPickerViewValueChanged(sender:)), for: .valueChanged)
    }
    func hidePickerView(){
        datePickerView.removeFromSuperview()
        
    }
}
extension BaseVC {
    @objc func didPickerViewValueChanged(sender: UIDatePicker) {
        pickerDelegate?.didSelectDatePicker?(date: sender.date)
        if pickerType == "date" {
            tempDate = sender.date
            selectedDateTextField.text = sender.date.stringFromDate(format: .mdytimeDate, type: .local)
        }else {
            selectedDateTextField.text = sender.date.stringFromDate(format: .localTime, type: .local)
        }
    }
}

//MARK: Alert Methods
extension BaseVC {
    
    func showAlert(title:String? = kSuccess, message: String?, cancelTitle: String? = nil,  cancelAction: ButtonAction? = nil, okayTitle: String = kOkay, _ okayAction: ButtonAction? = nil) {
        let alert = CustomAlert(title: title, message: message, cancelButtonTitle: cancelTitle, doneButtonTitle: okayTitle)
        alert.cancelButton.addTarget {
            cancelAction?()
            alert.remove()
        }
        
        alert.doneButton.addTarget {
            okayAction?()
            alert.remove()
        }
        alert.show()
    }
    
    func showErrorMessage(error: Error?) {
        /*
         STATUS CODES:
         200: Success (If request sucessfully done and data is also come in response)
         204: No Content (If request successfully done and no data is available for response)
         401: Unauthorized (If token got expired)
         402: Block (If User blocked by admin)
         403: Delete (If User deleted by admin)
         406: Not Acceptable (If user is registered with the application but not verified)
         */
        let message = (error as NSError?)?.userInfo[APIKeys.kMessage] as? String ?? kErrorMessage
        let alert = CustomAlert(title: kError, message: message, cancelButtonTitle: nil, doneButtonTitle: kOkay)
        alert.doneButton.addTarget {
            alert.remove()
            let code = (error! as NSError).code
            if code == 401 || code == 402 || code == 403 || code == 406 {
                self.logout()
            }
        }
        alert.show()
    }
    
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

//MARK: Show image picker
//extension BaseVC {
//
//    func showImagePicker() {
//        let alert  = UIAlertController(title: kAddProfileImage, message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: kGallery, style: .default, handler: {action in
//            let photos = PHPhotoLibrary.authorizationStatus()
//            if photos == .notDetermined ||  photos == .denied ||  photos ==  .restricted {
//                PHPhotoLibrary.requestAuthorization({status in
//                    if status == .authorized {
//                        CustomImagePickerView.sharedInstace.pickImageUsing(target: self, mode: .gallery)
//                    }
//                    else {
//                        DispatchQueue.main.async {
//                            self.showAlert(message: kGalleryMessage, {
//                                self.openSettings()
//                            })
//                        }
//                    }
//                })
//            }
//            else {
//                CustomImagePickerView.sharedInstace.pickImageUsing(target: self, mode: .gallery)
//            }
//        }))
//        alert.addAction(UIAlertAction(title: kCamera, style: .default, handler: {action in
//            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
//                if response {
//                    CustomImagePickerView.sharedInstace.pickImageUsing(target: self, mode: .camera)
//                } else {
//                    DispatchQueue.main.async {
//                        self.showAlert(message: kCameraMessage, {
//                            self.openSettings()
//                        })
//                    }
//                }
//            }
//        }))
//        alert.addAction(UIAlertAction(title: kCancel, style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func openGallery() {
//        let photos = PHPhotoLibrary.authorizationStatus()
//
//        if photos == .notDetermined {
//            PHPhotoLibrary.requestAuthorization({status in
//                if status == .authorized {
//                    CustomImagePickerView.sharedInstace.pickImageUsing(target: self, mode: .gallery)
//                }
//                else {
//
//                    DispatchQueue.main.async {
//                        self.showAlert(message: kGalleryMessage, {
//                            self.openSettings()
//                        })
//                    }
//
//                }
//            })
//        }
//        else  if photos == .authorized {
//            CustomImagePickerView.sharedInstace.pickImageUsing(target: self, mode: .gallery)
//        }
//        else {
//            DispatchQueue.main.async {
//                self.showAlert(message: kGalleryMessage, {
//                    self.openSettings()
//                })
//            }
//        }
//    }
//}
