//
//  ShowTimingVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit

class ShowTimingVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    
    //MARK: Variables
    var titleString = String()
    var selectedDate = String()
    var datepopvc: DatePopOverVC!
    var isFromCinema = false
    
    
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.set(title: titleString, showBack: true)
//        let keys = MovieListVM.shared.timeDict.keys.sorted { (key1, key2) -> Bool in
//            return key1 < key2
//        }
////        selectedDate = keys.first!
////        for dateString in keys {
//            let date = dateString.dateFromString(format: .daydm, type: .local)
//
//        }
        let dateString = Date().stringFromDate(format: .daydm, type: .local)
        selectedDate = dateString
        dateButton.setTitle(selectedDate, for: .normal)
        dateButton.setTitle(selectedDate, for: .selected)
        tableView.reloadData()
        if isFromCinema {
            languageButton.isHidden = true
        }
        else {
            languageButton.setTitle(MovieListVM.shared.languageTitle, for: .normal)
            languageButton.setTitle(MovieListVM.shared.languageTitle, for: .selected)
        }
    }
    
    @IBAction func dateButtonAction(_ sender: UIButton) {
        dateButton.isSelected = !dateButton.isSelected
        
        datepopvc = storyboard?.instantiateViewController(withIdentifier: "DatePopOverVC") as? DatePopOverVC
        datepopvc.modalPresentationStyle = UIModalPresentationStyle.popover
        datepopvc.preferredContentSize = CGSize(width: 320, height: 70)
        datepopvc.selectedDate = self.selectedDate
        datepopvc.delegate = self
        let popController = datepopvc.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.backgroundColor = UIColor.white
        popController?.delegate = self
        popController?.sourceRect = CGRect(x: 10, y: -35 , width: 320 , height: 70)
        popController?.sourceView =  sender
        self.present(datepopvc, animated: true, completion: {
            self.datepopvc.view.superview?.layer.cornerRadius = 5
        })
    }
    
}
//MARK: UIPopoverControllerDelegate
extension ShowTimingVC: UIPopoverPresentationControllerDelegate {
    
     func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
     func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        dateButton.isSelected = false
        return true
    }
}

//MARK: - UITableViewDataSource
extension ShowTimingVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cinemaDict = MovieListVM.shared.timeDict[selectedDate] as? JSONDictionary
        return cinemaDict?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTimingDetailsCell) as! TimingDetailsCell
        let cinemaDict = MovieListVM.shared.timeDict[selectedDate] as! JSONDictionary
        let keys = cinemaDict.keys.sorted { (key1, key2) -> Bool in
            return key1 < key2
        }
        cell.cinemaNameLabel.text = keys[indexPath.row]
        cell.setupCollectionView(delegate: self, forRow: indexPath.row)
        cell.baseView.setShadow()
        cell.timingCollectionViewHeight.constant =  cell.showTimingCollectionView.collectionViewLayout.collectionViewContentSize.height
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension ShowTimingVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


//MARK: - UICollectionViewDataSource
extension ShowTimingVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cinemaDict = MovieListVM.shared.timeDict[selectedDate] as! JSONDictionary
        let keys = cinemaDict.keys.sorted { (key1, key2) -> Bool in
            return key1 < key2
        }
        let array = cinemaDict[keys[collectionView.tag]] as? [TimeDetails]
        return array?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kShowTimingCell, for: indexPath) as! ShowTimingCell
        cell.baseView.set(radius: 3.0, borderColor: AppColor.navigationColor.color(),borderWidth: 1.0)
        let cinemaDict = MovieListVM.shared.timeDict[selectedDate] as! JSONDictionary
        let keys = cinemaDict.keys.sorted { (key1, key2) -> Bool in
            return key1 < key2
        }
        let array = cinemaDict[keys[collectionView.tag]] as? [TimeDetails]
        cell.timingLabel.text = array?[indexPath.row].time
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate
extension ShowTimingVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cinemaDict = MovieListVM.shared.timeDict[selectedDate] as! JSONDictionary
        let keys = cinemaDict.keys.sorted { (key1, key2) -> Bool in
            return key1 < key2
        }
        let array = cinemaDict[keys[collectionView.tag]] as? [TimeDetails]
        if let url = array?[indexPath.row].url {
            UIApplication.shared.open(url)
        }
    } 
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ShowTimingVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 4 ) - 2, height: 42)
    }
}

//MARK: Time Delegate
extension ShowTimingVC: TimeDelegate {
    
    func didSelectDate(date: String) {
        self.selectedDate = date
        tableView.reloadData()
        dateButton.setTitle(selectedDate, for: .normal)
        dateButton.setTitle(selectedDate, for: .selected)
        datepopvc.dismiss(animated: true, completion: nil)
        dateButton.isSelected = false
    }
}


