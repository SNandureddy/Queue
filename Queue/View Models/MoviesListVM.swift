//
//  MoviesListVM.swift
//  Queue
//
//  Created by Deftsoft on 20/03/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import Foundation

class MovieListVM {
    
    public static let shared = MovieListVM()
    private init(){}
    
    var moviesDictionary = [String: [MovieDetails]]()
    var moviesArray = [MovieDetails]()
    var languageTitle = String()
    var movieNameArray = [MovieName]()
    var timeDict = JSONDictionary()
    
    func callApiToMovieList(dict: JSONDictionary, isAll: Bool = true, response: @escaping responseCallBack) {
        APIManager.getMovieList(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            if isAll {
                self.parseMoviesData(response: responseDict)
            }
            else {
                self.parseMovieNames(response: responseDict)
            }
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callPaiToGetShowtimes(dict: JSONDictionary, isMovies: Bool = false,response: @escaping responseCallBack) {
        APIManager.getShowtimes(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.parseShowTimingData(response: responseDict, isMovies: isMovies)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
}
