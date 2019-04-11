//
//  ContactVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit



class ContactVC: BaseVC {
    //MARK: - IBOutlet
    @IBOutlet var nameTextField: TextField!
    @IBOutlet var emailTextField: TextField!
    @IBOutlet var viewForTextView: UIView!
    @IBOutlet var sendBUtton: UIButton!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.set(title: kContactUs, showBack: true)
        sendBUtton.set(radius: 5.0)
        nameTextField.set(radius: 5.0, borderColor: .lightGray, borderWidth: 1.0)
        emailTextField.set(radius: 5.0, borderColor: .lightGray, borderWidth: 1.0)
        viewForTextView.set(radius: 5.0, borderColor: .lightGray, borderWidth: 1.0)
    }

   
    @IBAction func sendButtonAction(_ sender: Any) {
        showAlert(title: kSuccess, message: "Thanks for sending us a message. We will contact you soon.", cancelTitle: nil, cancelAction: nil, okayTitle: kOkay) {
    
    self.tabBarController?.selectedIndex = 0
    }
    }
}

//MARTK: - UITextFieldDelegate
extension ContactVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension ContactVC: UITextViewDelegate {
    
    
    // hides text views
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
