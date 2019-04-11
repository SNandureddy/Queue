//
//  TermConditionVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class TermConditionVC: BaseVC {

    //variables
    var screenType = 1          // 1 : term condition(before login) , 2 : privacy policy , 3 : termCondition from settings
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if screenType == 1 || screenType == 4{
            self.set(title: kTermPolicyTitle, showRight: true, rightImage: #imageLiteral(resourceName: "Cross"))
        }else if screenType == 2 {
            self.set(title: kPrivacyPolicy, showRight: true, rightImage: #imageLiteral(resourceName: "Cross"))
        }else {
             self.set(title: kTermConditions, showRight: true, rightImage: #imageLiteral(resourceName: "Cross"))
        }
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    

        override func rightBarButtonAction(_ sender: UIButton) {
        super.rightBarButtonAction(sender)
        if screenType == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: kSelectLocationVC) as! SelectLocationVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
   

}

