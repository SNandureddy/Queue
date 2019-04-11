//
//  MovieListDataModel.swift
//  Queue
//  Created by Deftsoft on 20/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.

import Foundation

struct CastDetails{
    var name: String?
    var id: String?
    var character: String?
}

struct CrewDetails{
    var name: String?
    var id: String?
    var job: String?
}

struct TimeDetails {
    var time: String!
    var url: URL?
}

struct MovieGenres{
    var movieGenreName: String?
    var movieGenreid: String?
}

struct MovieName {
    var name: String?
    var id: String?
}

struct MovieDetails{
    
    var id: String?
    var slug: String?
    var title: String?
    var imageUrl: String?
    var language: String?
    var description: String?
    var duration: Int?
    var imdbId: String?
    var tmdbId: String?
    var productionCompany: String?
    var imdbStarValue: Double?
    var imdbStarCount: Int?
    var tmdbStarValue: Double?
    var tmdbStarCount: Int?
    var releaseDate: String?
    var releaseCountry: String?
    var countryAgeLimit: String?
    var trailerFiles: String?
    var trailorUrl: String?
    var movieGenre = [MovieGenres]()
    var castDetails = [CastDetails]()
    var crewDetails = [CrewDetails]()
    var posterImage: URL?
    
    init(details:JSONDictionary = JSONDictionary()) {
        self.id = details[APIKeys.kMovieId] as? String ?? "0"
        self.slug = details[APIKeys.kMovieSlug] as? String
        self.title = details[APIKeys.kOriginalTitle] as? String
        self.imageUrl = details[APIKeys.kMovieImage] as? String
        self.language = details[APIKeys.kMovieLanguage] as? String
        self.description = details[APIKeys.kMovieDescription] as? String
        self.duration = details[APIKeys.kMovieDuration] as? Int
        self.imdbId = details[APIKeys.kImdbId] as? String ?? "0"
        self.tmdbId = details[APIKeys.kTmdbId] as? String
        self.productionCompany = details[APIKeys.kProductionCompanies] as? String ?? ""
        
        if let movieType = details[APIKeys.kMovieType] as? JSONArray {
            self.movieGenre = [MovieGenres]()
            for movietype in movieType{
                let movieGenreName = movietype[APIKeys.kMovieGenreName] as? String
                let movieGenreId = movietype[APIKeys.kMovieGenreId] as? String
                self.movieGenre.append(MovieGenres(movieGenreName: movieGenreName, movieGenreid: movieGenreId))
            }
        }
        
        if let castDetails = details[APIKeys.kCast] as? JSONArray{
            self.castDetails = [CastDetails]()
            for cast in castDetails{
                let name = cast[APIKeys.kCastName] as? String
                let id = cast[APIKeys.kCastId] as? String
                let character = cast[APIKeys.kCastCharacter] as? String
                self.castDetails.append(CastDetails(name: name, id: id, character: character))
            }
        }
        
        if let crewDetails = details[APIKeys.kCrew] as? JSONArray{
            self.crewDetails = [CrewDetails]()
            for cast in crewDetails{
                let name = cast[APIKeys.kCrewName] as? String
                let id = cast[APIKeys.kCrewId] as? String
                let job = cast[APIKeys.kCrewJob] as? String
                self.crewDetails.append(CrewDetails(name: name, id: id, job: job))
            }
        }
        
        if let starRating = details[APIKeys.kRatings] as? JSONDictionary{
            if let imdbRating = starRating[APIKeys.kImdbRating] as? JSONDictionary{
                self.imdbStarValue = imdbRating[APIKeys.kImdbRatingsValue] as? Double
                self.imdbStarCount = imdbRating[APIKeys.kImdbRatingVoteCount] as? Int
            }
            if let tmbdrating = starRating[APIKeys.kTmdbRatings] as? JSONDictionary{
                self.tmdbStarValue = tmbdrating[APIKeys.kTmdbRatingsValue] as? Double
                self.tmdbStarCount = tmbdrating[APIKeys.kTmdbRatingsVoteCount] as? Int
            }
        }
        
        if let movieReleaseDates = details[APIKeys.kReleaseDate] as? JSONDictionary{
            if let releaseDetails = movieReleaseDates[DataManager.countryCode!] as? JSONArray {
                let releaseDetail = releaseDetails[0]
                self.releaseDate  = releaseDetail[APIKeys.kDate] as? String
                self.releaseCountry = DataManager.countryName
            }else {
                let releaseDetails = movieReleaseDates.values.first as? JSONArray
                let releaseDetail = releaseDetails?[0]
                self.releaseDate  = releaseDetail?[APIKeys.kDate] as? String
                self.releaseCountry = movieReleaseDates.keys.first
            }
        }
        
        if let trailors = details[APIKeys.kYoutubeTrailor] as? JSONArray{
            for data in trailors{
                if let trailerFiles = data[APIKeys.kTrailerFiles] as? JSONArray{
                    for files in trailerFiles{
                        self.trailorUrl = files[APIKeys.kYoutubeTrailorUrl] as? String
                    }
                }
            }
        }
        
        if let posterImages = details[APIKeys.kPosterImage] as? JSONDictionary {
            if let imageArray = posterImages[APIKeys.kImageFiles] as? JSONArray {
                if imageArray.count > 0 {
                    let urlString = imageArray.last![APIKeys.kURL] as? String ?? ""
                    let url = URL(string: urlString)
                    self.posterImage = url
                }
            }
        }
//
        if let ageLimits = details[APIKeys.kAgelimits] as? JSONDictionary{
            self.countryAgeLimit = ageLimits[APIKeys.kCountryAgeLimit] as? String
        }
    }
}

// Parsing Data
extension MovieListVM{
    
    func parseMoviesData(response:JSONDictionary){
        moviesArray = [MovieDetails]()
        if let movies = response[APIKeys.kMovieList] as? JSONArray {
            for movie in movies {
                let moviedetails = MovieDetails(details: movie)
                moviesArray.append(moviedetails)
            }
        }
        
        self.moviesDictionary.removeAll()
        for movie in moviesArray {
            for genres in movie.movieGenre {
                let name = genres.movieGenreName ?? ""
                if !name.isEmpty {
                    if self.moviesDictionary.keys.contains(genres.movieGenreName ?? "") {
                        var values = self.moviesDictionary[genres.movieGenreName ?? ""]
                        values?.append(movie)
                        values!.sort(by: {$0.title?.localizedCaseInsensitiveCompare($1.title ?? "") == ComparisonResult.orderedAscending})
                        self.moviesDictionary[genres.movieGenreName ?? ""] = values ?? [movie]
                    }
                    else {
                        self.moviesDictionary[genres.movieGenreName ?? ""] = [movie]
                    }
                }
            }
        }
        
        moviesArray.sort(by: {$0.title?.localizedCaseInsensitiveCompare($1.title ?? "") == ComparisonResult.orderedAscending})
        self.moviesDictionary["All Movies"] = moviesArray
    }
    
    func parseMovieNames(response: JSONDictionary) {
        movieNameArray = [MovieName]()
        if let movieArray = response[APIKeys.kMovies] as? JSONArray {
            for movie in movieArray {
                let name = movie[APIKeys.kMovieTitle] as? String ?? ""
                let id = movie[APIKeys.kID] as? String ?? ""
                movieNameArray.append(MovieName(name: name, id: id))
            }
        }
    }
    
    func parseShowTimingData(response: JSONDictionary, isMovies: Bool = false) {
        timeDict.removeAll()
        if let showTimeAraray = response[APIKeys.kShowTimes] as? JSONArray {
            for timeDict in showTimeAraray {
                let cinemaID = timeDict[APIKeys.kCinemaId] as! String
                let movieID = timeDict["movie_id"] as? String ?? ""

                var name = String()
                if isMovies {
                    let movie = MovieListVM.shared.movieNameArray.filter({($0.id ?? "") == movieID})
                    name = movie.first?.name ?? ""
                }
                else {
                    let cinema = CinemaListVM.shared.cinemasArray.filter({$0.cinemaId! == cinemaID})
                    name = cinema.first?.cinemaName ?? ""
                }
                let startDate = timeDict[APIKeys.kStartAt] as? String ?? ""
                let date = self.convertDateFromString(date: startDate)
                if date < Date() {continue}
                let dateString = date.stringFromDate(format: .daydm, type: .local)
                let timeString = date.stringFromDate(format: .localTime, type: .local)
                let language = timeDict[APIKeys.kLanguage] as? String ?? "en"
                let languageName = language.languageName
                let is3D = timeDict[APIKeys.kIs3D] as! Bool
                let urlString = timeDict[APIKeys.kBookingLink] as? String ?? ""
                let url = URL(string: urlString)
                languageTitle = "\(languageName) \(is3D ? "3D":"2D")"
                if var dict = self.timeDict[dateString] as? JSONDictionary {
                    if var timeArray = dict[name] as? [TimeDetails] {
                        let time = TimeDetails(time: timeString, url: url)
                        timeArray.append(time)
                    }
                    else {
                        let time = TimeDetails(time: timeString, url: url)
                        dict[name] = [time]
                    }
                    self.timeDict[dateString] = dict
                }
                else {
                    let time = TimeDetails(time: timeString, url: url)
                    let dict = [name: [time]]
                    self.timeDict[dateString] = dict
                }
            }
        }
    }
    
    func convertDateFromString(date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let s = dateFormatter.date(from: date)
        return s!
    }

}

