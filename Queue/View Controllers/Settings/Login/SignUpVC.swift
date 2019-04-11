
//
//  SignUpVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class SignUpVC: BaseVC {

    //MARK: IBOutlets
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    //MARK: Class Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customUI()
    }
    
    //MARK: Private Methods
    func customUI() {
        set(title: "Sign Up")
        for textField in textFieldCollection{
            textField.set(radius: 5.0, borderColor: .lightGray, borderWidth: 1.0)
        }
        signUpButton.set(radius: 5.0)
        signInButton.set(radius: 5.0, borderColor: #colorLiteral(red: 0.5284405351, green: 0.0784002617, blue: 0.09743902832, alpha: 1), borderWidth: 1.0)
    }
    
    //MARK: IBActions
    @IBAction func termPrivacyPolicyAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: kTermConditionVC) as! TermConditionVC
        vc.screenType = 4
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        self.signup()
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
    
    @IBAction func checkAction(_ sender: UIButton) {
        checkButton.isSelected = !checkButton.isSelected
    }
    
}

//MARTK: TextField Delegates
extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == textFieldCollection[0] { //Name
            return newLength <= 40
        }
        if textField == textFieldCollection[1] { //Email
            return newLength <= 80
        }
        return true
    }
}

//MARK: Validations
extension SignUpVC {
    
    func validateData() -> String? {
        if textFieldCollection[0].isEmpty { //Name
            return kEmptyName
        }
        if !textFieldCollection[0].isValidName { //Name
            return kValidName
        }
        if textFieldCollection[1].isEmpty { //Email
            return kEmptyEmail
        }
        if !textFieldCollection[1].isValidEmail { //Email
            return kValidEmail
        }
        if textFieldCollection[2].isEmpty { //Password
            return kEmptyPassword
        }
        if !textFieldCollection[2].isValidPassword { //Password
            return kValidPassword
        }
        if textFieldCollection[3].isEmpty { //Confirm Password
            return kEmptyConfirmPassword
        }
        if textFieldCollection[2].text! != textFieldCollection[3].text! { //Confirm Password
            return kValidConfirmPassword
        }
        if !checkButton.isSelected {
            return kAcceptTerms
        }
        return nil
    }
}

//MARK: API Methods
extension SignUpVC {
    
    func signup() {
        if let message = self.validateData() {
            self.showAlert(title: kError, message: message)
            return
        }
        var dict = JSONDictionary()
        dict[APIKeys.kFullName] = textFieldCollection[0].text!
        dict[APIKeys.kEmail] = textFieldCollection[1].text!
        dict[APIKeys.kPassword] = textFieldCollection[2].text!
        dict[APIKeys.kDeviceType] = 1
        UserVM.shared.signup(dict: dict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                self.showAlert(message: message, {
                    self.backButtonAction()
                })
            }
        }
    }
}
