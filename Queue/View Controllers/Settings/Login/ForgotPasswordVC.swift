//
//  ForgotPasswordVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseVC {

    //MARK: IBOutlets
    @IBOutlet var EmailTextField: TextField!
    @IBOutlet var sendButton: UIButton!
    
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
        set(title: "Forgot Password", showBack: true)
        EmailTextField.set(radius: 5.0, borderColor: .lightGray, borderWidth: 1.0)
        sendButton.set(radius: 5.0)
    }

    //MARK: IBActions
    @IBAction func sendButtonAction(_ sender: Any) {
        forgotPassword()
    }
}

//MARTK: TextField Delegates
extension ForgotPasswordVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

//MARK: Validations
extension ForgotPasswordVC {
    
    func validateData() -> String? {
        if EmailTextField.isEmpty {
            return kEmptyEmail
        }
        if !EmailTextField.isValidEmail {
            return kValidEmail
        }
        return nil
    }
}

extension ForgotPasswordVC {
    
    func forgotPassword() {
        if let message = validateData() {
            self.showAlert(title: kError, message: message)
            return
        }
        UserVM.shared.forgotPassword(email: EmailTextField.text!) { (message, error) in
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
