//
//  TabBarVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit


class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarItem.appearance(whenContainedInInstancesOf: [TabBarVC.self])
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray         ], for: .normal)
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColor.navigationColor.color()], for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }

}
