//
//  HomeVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class HomeVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet var searchView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callApitoMovieList()
        customUI()
    }
    
    //MARK: Private Methods
    private func customUI() {
        searchBarTextField.text = kEmptyString
        self.set(title: kEmptyString)
        searchView.set(radius: 2.0)
        searchView.setShadow()
        bannerView.rootViewController = self
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-4971652510282856/2475672996"
        bannerView.isAutoloadEnabled = true
    }
    
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender.text == "" {
            self.filterMovies(array: MovieListVM.shared.moviesArray)
        }
        else {
            let filterArray = MovieListVM.shared.moviesArray.filter({($0.title ?? "").lowercased().contains(sender.text!.lowercased())})
            self.filterMovies(array: filterArray)
        }
    }
}


//MARK: UITableViewDataSource
extension HomeVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return MovieListVM.shared.moviesDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMoviesCell) as! MoviesCell
        cell.setupCollectionView(delegate: self, forRow: indexPath.section)
        return cell
    }
}


//MARK: UITableViewDelegate
extension HomeVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMoviesHeaderCell) as! MoviesHeaderCell
        var keys = MovieListVM.shared.moviesDictionary.keys.sorted { (key1, key2) -> Bool in
            return key1 < key2
        }
        if let index = keys.firstIndex(of: kAllMovies) {
            keys.remove(at: index)
            keys.insert(kAllMovies, at: 0)
        }
        cell.headerLabel.text = keys[section]
        return cell
    }
}

//MARK: UICollectionViewDataSource
extension HomeVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var keys = MovieListVM.shared.moviesDictionary.keys.sorted { (key1, key2) -> Bool in
            return key1 < key2
        }
        if let index = keys.firstIndex(of: kAllMovies) {
            keys.remove(at: index)
            keys.insert(kAllMovies, at: 0)
        }

        return MovieListVM.shared.moviesDictionary[keys[collectionView.tag]]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMovieCell, for: indexPath) as! MovieCell
        var keys = MovieListVM.shared.moviesDictionary.keys.sorted { (key1, key2) -> Bool in
            return key1 < key2
        }
        if let index = keys.firstIndex(of: kAllMovies) {
            keys.remove(at: index)
            keys.insert(kAllMovies, at: 0)
        }

        
        let movie = MovieListVM.shared.moviesDictionary[keys[collectionView.tag]]?[indexPath.row]
        cell.movieTitleLabel.text = movie?.title
        cell.movieImageView.sd_setImage(with: URL(string: movie?.imageUrl ?? ""), placeholderImage: #imageLiteral(resourceName: "palceholder"), options: .refreshCached, completed: nil)
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension HomeVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: kMovieDetailsVC) as! MovieDetailsVC
        var keys = MovieListVM.shared.moviesDictionary.keys.sorted { (key1, key2) -> Bool in
            return key1 < key2
        }
        if let index = keys.firstIndex(of: kAllMovies) {
            keys.remove(at: index)
            
            keys.insert(kAllMovies, at: 0)
        }
        let movie = MovieListVM.shared.moviesDictionary[keys[collectionView.tag]]?[indexPath.row]
        vc.movie = movie ?? MovieDetails()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension HomeVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 200)
    }
}

//MARK: - UITextFieldDelegate
extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

//MARK: API Methods
extension HomeVC {
    
    func callApitoMovieList() {
        var dict = JSONDictionary()
        dict[APIKeys.kAllFields] = true
        dict[APIKeys.kCityIds] = BaseVC.cityId
        MovieListVM.shared.callApiToMovieList(dict: dict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
                self.tableView.reloadData()
            }
            else {
                self.tableView.reloadData()
            }
        }
    }
    
    func filterMovies(array: [MovieDetails]) {
        var movieDict = [String: [MovieDetails]]()
        for movie in array {
            for genres in movie.movieGenre {
                let name = genres.movieGenreName ?? ""
                if !name.isEmpty {
                    if movieDict.keys.contains(genres.movieGenreName ?? "") {
                        var values = movieDict[genres.movieGenreName ?? ""]
                        values?.append(movie)
                        values!.sort(by: {$0.title?.localizedCaseInsensitiveCompare($1.title ?? "") == ComparisonResult.orderedAscending})
                        movieDict[genres.movieGenreName ?? ""] = values ?? [movie]
                    }
                    else {
                        movieDict[genres.movieGenreName ?? ""] = [movie]
                    }
                }
            }
        }
        movieDict["All Movies"] = array
        MovieListVM.shared.moviesDictionary = movieDict
        tableView.reloadData()
    }
}
