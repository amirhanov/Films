//
//  Network.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import Alamofire
import Foundation

protocol NetworkServiceProtocol {
    func getFilms(complition: @escaping (Result<[Films]?, Error>) -> Void)
    func getDetailForFilm(id: Int, complition: @escaping (Result<Film?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    private var films: [Films] = []
    private var film: Film?
    private var genreName: String?
    
    func getFilms(complition: @escaping (Result<[Films]?, Error>) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(Constants.apiKey)&page=\(Constants.page)"
        AF.request(url).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                if let responseValue = value as? [String : Any] {
                    if let responseFilms = responseValue["results"] as! [[String : Any]]? {
                        for film in responseFilms {
                            let title = film["original_title"] as? String
                            let id = film["id"] as? Int
                            let poster = film["backdrop_path"] as? String
                            let language = film["original_language"] as? String
                            let overview = film["overview"] as? String
                            let vote = film["vote_average"] as? Double
                            let popular = film["popularity"] as? Double
                            
                            let film = Films(id: id!,
                                            overview: overview!,
                                            title: title!,
                                            language: language!,
                                            poster: poster!,
                                            popular: popular!,
                                            vote: vote!)
                            
                            films.append(film)
                        }
                        complition(.success(films))
                    }
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    func getDetailForFilm(id: Int, complition: @escaping (Result<Film?, Error>) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(Constants.apiKey)&language=\(Constants.language)"
        AF.request(url).responseJSON { [self] resonse in
            switch resonse.result {
            case .success(let value):
                if let responseValue = value as? [String : Any] {
                    if let responeGenres = responseValue["genres"] as! [[String : Any]]? {
                        for genre in responeGenres {
                            genreName = genre["name"] as? String
                        }
                    }
                    let adult = responseValue["adult"] as? Bool
                    let revenue = responseValue["revenue"] as? Int
                    let budget = responseValue["budget"] as? Int
                    let homepage = responseValue["homepage"] as? String
                    let overview = responseValue["overview"] as? String
                    let vote_count = responseValue["vote_count"] as? Int
                    let release_date = responseValue["release_date"] as? String
                    let vote_average = responseValue["vote_average"] as? Double
                    let poster_path = responseValue["poster_path"] as? String
                    let original_title = responseValue["original_title"] as? String
                    let runtime = responseValue["runtime"] as? Int
                    let tagline = responseValue["tagline"] as? String
                    
                    let detail = Film(genre: genreName!,
                                      adult: adult!,
                                      budget: budget!,
                                      homepage: homepage!,
                                      overview: overview!,
                                      release_date: release_date!,
                                      vote_count: vote_count!,
                                      vote_average: vote_average!,
                                      revenue: revenue!,
                                      poster_path: poster_path!,
                                      original_title: original_title!,
                                      runtime: runtime!,
                                      tagline: tagline!)
                    
                    film = detail
                    complition(.success(film))
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}
