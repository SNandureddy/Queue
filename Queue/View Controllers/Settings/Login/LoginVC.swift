//
//  LoginVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet var baseView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customUI()
    }
    
    override func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: IBActions
    @IBAction func loginButtonAction(_ sender: Any) {
        self.login()
    }

    //MARK: Private Methods
    private func customUI() {
        emailTextField.set(radius: 5.0, borderColor: .lightGray, borderWidth: 1.0)
        passwordTextField.set(radius: 5.0, borderColor: .lightGray, borderWidth: 1.0)
        loginButton.set(radius: 5.0, borderColor: AppColor.navigationColor.color(), borderWidth: 1.0)
        self.set(title: kLogin,showBack: true,backImage: #imageLiteral(resourceName: "Cross"))
    }
}

//MARK: Textfield Delegates
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

//MARK: Validations
extension LoginVC {
    
    func validateData() -> String? {
        if emailTextField.isEmpty {
            return kEmptyEmail
        }
        if !emailTextField.isValidEmail {
            return kValidEmail
        }
        if passwordTextField.isEmpty {
            return kEmptyPassword
        }
        if !passwordTextField.isValidPassword {
            return kValidPassword
        }
        return nil
    }
}

//MARK: API Methods
extension LoginVC {
    
    func login() {
        if let message = self.validateData() {
            self.showAlert(title: kError, message: message)
            return
        }
        var dict = JSONDictionary()
        dict[APIKeys.kEmail] = emailTextField.text!
        dict[APIKeys.kPassword] = passwordTextField.text!
        dict[APIKeys.kDeviceType] = 1
        
        UserVM.shared.login(dict: dict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                self.showAlert(title: kSuccess, message: message, okayTitle: kOkay, {
                    self.dismiss(animated: true, completion: nil)
                   self.tabBarController?.selectedIndex = 3
                })
            }
        }
    }
}

