//
//  SettingsVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit


class SettingsVC: BaseVC {
    
    //NARK: - @IBOutlet
    @IBOutlet var tableView: UITableView!
    
    //variables
   

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.set(title: kSettings, showBack: true)
        self.tableView.tableFooterView = UIView()
        
        if DataManager.accessToken == nil {
            if settingsArray.last == kChnagePasswordString{
                settingsArray.removeLast()
            }
        }else {
            if !settingsArray.contains(kChnagePasswordString) {
               settingsArray.insert(kChnagePasswordString, at: settingsArray.count)
            }
        }
        self.tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension SettingsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSettingCell) as! SettingCell
        cell.label.text = settingsArray[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SettingsVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: kTermConditionVC) as! TermConditionVC
            vc.screenType = 2
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated:true, completion: nil)
            break
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: kTermConditionVC) as! TermConditionVC
            vc.screenType = 3
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated:true, completion: nil)
            break
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: kChangePasswordVC) as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
}


