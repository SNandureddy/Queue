//
//  SearchVC.swift
//  
//
//  Created by Apple on 14/03/19.
//

import UIKit


class SearchVC: BaseVC {

    //MARK: IBOutlets
    @IBOutlet var locationView: UIView!
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchBarTextField: UITextField!
    
    
    
    //MARK: Variables
    var selectedCinema = String()
    var cinemaArray = [CinemaData]()

    //MARK: Class Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customUI()
        callApitoSearchCinemas()
    }

    //MARK: IBActions
    @IBAction func chnageLocationButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(storyboard: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: kSelectLocationVC ) as! SelectLocationVC
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
    //MARK: TextField Actions
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender.text == "" {
            self.cinemaArray = CinemaListVM.shared.cinemasArray
        }
        else {
            var filterArray = CinemaListVM.shared.cinemasArray.filter({($0.cinemaName ?? "").lowercased().contains(sender.text!.lowercased())})
            let pendingArray = CinemaListVM.shared.cinemasArray.filter({!($0.cinemaName ?? "").lowercased().contains(sender.text!.lowercased())})
            let zipArray = pendingArray.filter({($0.zipCode ?? "").lowercased().contains(sender.text!.lowercased())})
            filterArray.append(contentsOf: zipArray)
            self.cinemaArray = filterArray
        }
        tableView.reloadData()
    }
    
    
    //MARK: Private Methods
    private func customUI() {
        searchBarTextField.text = kEmptyString
        self.set(title: kEmptyString)
        searchView.set(radius: 2.0)
        locationView.set(radius: 0.0,borderColor: .lightGray, borderWidth: 0.5)
        locationButton.setTitle("You are in \(BaseVC.locationName)", for: .normal)
        locationButton.setTitle("You are in \(BaseVC.locationName)", for: .selected)
        searchView.setShadow()
        tableView.tableFooterView = UIView()
    }
}

//MARK: UITableViewDataSource
extension SearchVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cinemaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSearchResultCell) as! SearchResultCell
        cell.cinemaNameLabel.text = self.cinemaArray[indexPath.row].cinemaName
        cell.cinemaAdressLabel.text = self.cinemaArray[indexPath.row].displayText
        cell.telephoneNumberLabel.text = self.cinemaArray[indexPath.row].cinemaTelephone
        cell.websiteLabel.text = self.cinemaArray[indexPath.row].cinemaWebsite
        return cell
    }
}

//MARK:  UITableViewDelegate
extension SearchVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cinemaId = self.cinemaArray[indexPath.row].cinemaId
        selectedCinema = self.cinemaArray[indexPath.row].cinemaName ?? "No Name"
        self.getMovies(id: cinemaId ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARTK: UITextFieldDelegate
extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

//MARK: API Methods
extension SearchVC {
    
    func callApitoSearchCinemas()  {
        var dict = JSONDictionary()
        dict[APIKeys.kCityIds] = BaseVC.cityId
        CinemaListVM.shared.callApiToSearchCinema(dict: dict, response: { (message, error) in
            if error != nil{
                self.showErrorMessage(error: error)
            }
            else {
                self.cinemaArray = CinemaListVM.shared.cinemasArray
                self.tableView.reloadData()
            }
        })
    }
    
    func getMovies(id: String) {
        var dict = JSONDictionary()
        dict[APIKeys.kCityIds] = BaseVC.cityId
        dict[APIKeys.kCinemaId] = id
        MovieListVM.shared.callApiToMovieList(dict: dict, isAll: false, response: { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                self.getShowTimings(id: id)
            }
        })
    }
    
    func getShowTimings(id: String) {
        var dict = JSONDictionary()
        dict[APIKeys.kCinemaId] = id
        dict[APIKeys.kCityIds] = BaseVC.cityId
        MovieListVM.shared.callPaiToGetShowtimes(dict: dict, isMovies: true) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                let timevc = self.storyboard?.instantiateViewController(withIdentifier: kShowTimingVC) as! ShowTimingVC
                timevc.titleString = self.selectedCinema
                timevc.isFromCinema = true
                self.navigationController?.show(timevc, sender: self)
            }
        }
    }
}



