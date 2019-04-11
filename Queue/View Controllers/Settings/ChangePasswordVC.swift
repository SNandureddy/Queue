//
//  ChangePasswordVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseVC {

    //MARK: - IBOutlet
    @IBOutlet var textFieldCollection: [TextField]!
    @IBOutlet var changePassswordButton: UIButton!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.set(title: kChangePassword, showBack: true)
        for textField in textFieldCollection{
            textField.set(radius: 5.0, borderColor: .lightGray, borderWidth: 1.0)
        }
        changePassswordButton.set(radius: 5.0)
    }
    
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        showAlert(title: kSuccess, message: "Password changed successfully. Please login again.", cancelTitle: nil, cancelAction: nil, okayTitle: kOkay) {
             self.tabBarController?.selectedIndex = 3
        }
    }
}
//MARTK: - UITextFieldDelegate
extension ChangePasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
