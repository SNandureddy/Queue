//
//  SelectLocationVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit
import CoreLocation

class SelectLocationVC: BaseVC {

    //MARK: IBOutlets
    @IBOutlet weak var CurrentLocationButton: UIButton!
    @IBOutlet var currentLocationView: UIView!
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: Variables
    var screeType = 1 // navigating from (1 -> normal initial set up , 2-> more)
    var imageArray = [#imageLiteral(resourceName: "London"),#imageLiteral(resourceName: "Birmingham"),#imageLiteral(resourceName: "Liverpool"),#imageLiteral(resourceName: "Nottingham"),#imageLiteral(resourceName: "Sheffield"),#imageLiteral(resourceName: "Bristo")]
    var cityArray = ["London","Birmingham","Liverpool","Nottingham","Sheffield", "Bristol"]
    var idArray = ["904", "926", "944", "987", "951", "965"]
    var cityListArray = [CityDetails]()
    
    //MARK: Class Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customUI()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        self.callAPItoGetCities()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if BaseVC.locationName == "" {
            let emptyImage = UIImage()
            self.set(title: kSelectLocation, showRight: true, rightImage: emptyImage )
        }
        else {
           self.set(title: kSelectLocation, showRight: true, rightImage: #imageLiteral(resourceName: "Cross"))
        }
    }
    
    override func rightBarButtonAction(_ sender: UIButton) {
        super.rightBarButtonAction(sender)
        if BaseVC.locationName == "" {
            sender.isUserInteractionEnabled = false
        }
        else if screeType == 1 {
            DataManager.firstTime = true
            self.goToHome()
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Private Methods
    private func customUI() {
        self.set(title: kSelectLocation, showRight: true, rightImage: #imageLiteral(resourceName: "Cross"))
        searchView.set(radius: 2.0)
        currentLocationView.set(radius: 0.0,borderColor: .lightGray, borderWidth: 0.5)
        searchView.setShadow()
        tableView.tableFooterView = UIView()
        tableView.set(radius: 0.0, borderColor: UIColor.lightGray, borderWidth: 0.5)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            tableViewBottomConstraint.constant = -keyboardHeight
        }
    }

    //MARK: - IBAction
    @IBAction func selectLocationButtonAction(_ sender: Any) {
        if LocationManager.shared.isLoocationAccessEnabled(){
            self.getCurrentLocation { (success) in
                if success {
                    if let index = CinemaListVM.shared.cityArray.firstIndex(where: {($0.name ?? "") == self.address}) {
                        self.searchTextField.text = self.address
                        BaseVC.locationName = self.address
                        DataManager.location = self.address
                        BaseVC.cityId = CinemaListVM.shared.cityArray[index].id ?? "0"
                        DataManager.cityId = BaseVC.cityId
                    }
                    else {
                        self.showAlert(title: kSorry, message: kLocationNotAVailable)
                    }
                }
                else {
                    self.searchTextField.text = ""
                }
            }
        }
        else {
            self.showAlert(message: kLocationMessage, {
                self.openSettings()
            })
        }
    }
    
    //MARK: TextField Actions
    @IBAction func textfieldDidChange(_ sender: UITextField) {
        if sender.text == "" {
            self.cityListArray = CinemaListVM.shared.cityArray
            tableView.isHidden = true
        }
        else {
            let filterArray = CinemaListVM.shared.cityArray.filter({($0.name ?? "").lowercased().contains(sender.text!.lowercased())})
            tableView.isHidden = filterArray.count == 0
            self.cityListArray = filterArray
        }
        tableView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource
extension SelectLocationVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kLoactionCell, for: indexPath) as! LoactionCell
        cell.imageView.image = imageArray[indexPath.item]
        cell.label.text = cityArray[indexPath.item]
        cell.baseView.set(radius: 1.0, borderColor: .lightGray, borderWidth: 0.5)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension SelectLocationVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         BaseVC.cityId = idArray[indexPath.item]
        DataManager.cityId = BaseVC.cityId
        searchTextField.text = cityArray[indexPath.item]
        BaseVC.locationName = cityArray[indexPath.item]
        DataManager.location = cityArray[indexPath.item]

        if screeType == 1 {
            DataManager.firstTime = true
            self.goToHome()
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SelectLocationVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 , height: 100)
    }
}

//MARTK: - UITextFieldDelegate
extension SelectLocationVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}

//MARK: Tableview Datasource
extension SelectLocationVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPlaceCell)!
        cell.textLabel?.text = self.cityListArray[indexPath.row].name
        return cell
    }
}

extension SelectLocationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BaseVC.locationName = self.cityListArray[indexPath.row].name ?? ""
        BaseVC.cityId = self.cityListArray[indexPath.row].id ?? ""
        DataManager.cityId = BaseVC.cityId
        DataManager.location = BaseVC.locationName
        searchTextField.text = BaseVC.locationName
        tableView.isHidden = true
        searchTextField.resignFirstResponder()
    }
}

//MARK: API Methods
extension SelectLocationVC {
    
    func callAPItoGetCities() {
        CinemaListVM.shared.getCities { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                self.cityListArray = CinemaListVM.shared.cityArray
            }
        }
    }
}
