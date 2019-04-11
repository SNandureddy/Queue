
//
//  SettingsVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit


class MoreVC: BaseVC {
    
    //NARK: - @IBOutlet
    @IBOutlet var tableView: UITableView!
     @IBOutlet var headerView: UIView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    //variables
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.set(title: kEmptyString)
//        self.navigationController?.navigationBar.isHidden = true
        self.tableView.tableFooterView = UIView()
        manageHeaderView()
        
    }
    
    func manageHeaderView(){
//        self.headerView.backgroundColor = AppColor.navigationColor.color()
        if DataManager.accessToken == nil {
            self.userNameLabel.isHidden = true
            self.userEmailLabel.isHidden = true
            self.editButton.setImage(#imageLiteral(resourceName: "Right_arrow"), for: .normal)
            self.loginButton.isHidden = false
            if menuArray.last == kLogoutString{
                menuArray.removeLast()
            }
        }else {
            self.userNameLabel.isHidden = false
            self.userEmailLabel.isHidden = false
             self.editButton.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
            self.loginButton.isHidden = true
            self.userNameLabel.text = DataManager.name
            self.userEmailLabel.text = DataManager.email
            if !menuArray.contains(kLogoutString) {
                menuArray.insert(kLogoutString, at: menuArray.count)
            }
        }
        self.tableView.reloadData()
    }
    
}

//MARK: - UITableViewDataSource
extension MoreVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSettingCell) as! SettingCell
        cell.label.text = menuArray[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MoreVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case 0:
            let storyboard = UIStoryboard(storyboard: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: kSelectLocationVC) as! SelectLocationVC
            vc.screeType = 2
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated:true, completion: nil)
            break
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: kContactVC) as! ContactVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            
            break
        case 3:
    
            break
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: kSettingsVC) as! SettingsVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5:
            //logout
            self.showAlert(title: "Are you sure?" , message: "You want to logout.", cancelTitle: "CANCEL", cancelAction: nil, okayTitle: "YES") {
               self.logout()
                self.tabBarController?.selectedIndex = 0
            }
            
            break
            
        default:
            break
        }
    }
}


