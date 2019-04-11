//
//  MovieDetailsVC.swift
//  Queue
//
//  Created by Apple on 14/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import UIKit
import FloatRatingView

let kMovieDetailsVC = "MovieDetailsVC"//vc
let kCrewCell1 = "CrewCell1"//cell
let kCrewCell2 = "CrewCell2"
let kCrewCell3 = "CrewCell3"


class MovieDetailsVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet var castCollectionView: UICollectionView!
    @IBOutlet var crewCollcetionView: UICollectionView!
    @IBOutlet var companiesCollectionView: UICollectionView!
    @IBOutlet var showTimingButton: UIButton!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieReleasingDateLAbel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var trailorWatchNowLabel: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ageLimitLabel: UILabel!
    @IBOutlet weak var imdbIdLabel: UILabel!
    @IBOutlet weak var tmdbIdLabel: UILabel!
    @IBOutlet weak var imdbStarRatingView: FloatRatingView!
    @IBOutlet weak var tmdbStarRatingView: FloatRatingView!
    @IBOutlet weak var releasingDateRegionLabel: UILabel!
    
    //MARK: Variables
    var movie = MovieDetails()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        set(title: "Movie Name",showBack: true)
        showTimingButton.set(radius: 5.0)
        setMovieDetails()
    }

    //MARK: Private Methods
    private func setMovieDetails(){
        movieNameLabel.text = movie.title
        movieImage.sd_setImage(with: movie.posterImage, placeholderImage: #imageLiteral(resourceName: "palceholder"), options: .refreshCached, completed: nil)
        movieLanguageLabel.text = (movie.language ?? "en").languageName
        let durationMinutes = movie.duration ?? 0
        
        movieDurationLabel.text = convertedTime(seconds: Double(durationMinutes*60))
        movieGenreLabel.text = movie.movieGenre.compactMap({$0.movieGenreName}).joined(separator: ",")
        descriptionLabel.text = movie.description
        imdbIdLabel.text = movie.imdbId
        tmdbIdLabel.text = movie.tmdbId
        imdbStarRatingView.rating = (movie.imdbStarValue ?? 0.0) / 2
        tmdbStarRatingView.rating = (movie.tmdbStarValue ?? 0.0) / 2
        movieReleasingDateLAbel.text = movie.releaseDate
        let tap = UITapGestureRecognizer(target: self, action: #selector(MovieDetailsVC.tapFunction))
        trailorWatchNowLabel.addGestureRecognizer(tap)
    }
    
    private func convertedTime (seconds : Double) -> String {
        let (hr,  minf) = modf (seconds / 3600)
        let (min, _) = modf (60 * minf)
        return "\(Int(hr)) hours \(Int(min)) minutes"
    }

    
    @objc func tapFunction(sender: UITapGestureRecognizer) {
        let url = movie.trailorUrl
        UIApplication.shared.open(URL(string: url ?? "")!, options: [:], completionHandler: nil)
    }
    
    //MARK: IBActions
    @IBAction func showTimingsAction(_ sender: UIButton) {
        getCinemas()
    }
    
}

//MARK: UICollectionViewDataSource
extension MovieDetailsVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castCollectionView {
            return  movie.castDetails.count
            
        }
        else if collectionView == crewCollcetionView {
            return movie.crewDetails.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCrewCell1, for: indexPath) as! CrewCell
            cell.castNameLabel.text = movie.castDetails[indexPath.row].name
            cell.castCharacterLabel.text = movie.castDetails[indexPath.row].character
            
            return cell
        }
        else if collectionView == crewCollcetionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCrewCell2, for: indexPath) as! CrewCell
            cell.crewNameLabel.text = movie.crewDetails[indexPath.row].name
            cell.crewJobLabel.text = movie.crewDetails[indexPath.row].job
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCrewCell3, for: indexPath) as! CrewCell
            return cell
        }
    }
}

//MARK: API Methods
extension MovieDetailsVC {
    
    func getShowTimings() {
        var dict = JSONDictionary()
        dict["movie_id"] = movie.id!
        dict[APIKeys.kCityIds] = BaseVC.cityId
        MovieListVM.shared.callPaiToGetShowtimes(dict: dict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                let timevc = self.storyboard?.instantiateViewController(withIdentifier: kShowTimingVC) as! ShowTimingVC
                timevc.titleString = self.movie.title ?? "No Name"
                self.navigationController?.show(timevc, sender: self)
            }
        }
    }
    
    func getCinemas()  {
        var dict = JSONDictionary()
        dict[APIKeys.kCityIds] = BaseVC.cityId
        CinemaListVM.shared.callApiToSearchCinema(dict: dict) { (message, error) in
            if error != nil {
                self.showErrorMessage(error: error)
            }
            else {
                self.getShowTimings()
            }
        }
    }
}
