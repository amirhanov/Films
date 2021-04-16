//
//  FilmsPresenter.swift
//  Films
//
//  Created by MOrlov on 16.04.2021.
//

import Foundation
import Alamofire

protocol FilmsControllerOutput: AnyObject {
    func viewDidLoad()
}

class FilmsPresenter {
    
    // MARK: - Public Properties
    
    weak var view: FilmsControllerInput?
    var router: FilmsRouterInput?
    
    // MARK:  - Private Properties
    
    private var page = 1
    private var films = [Film]()
    
    // MARK: - Private Methods
    
    private func fetchFilms() {
        let url = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(Constants.apiKey)&page=\(page)"
        AF.request(url).responseJSON { [weak self] response in
            guard let self = self else { return } // MARK: - Вот тут обязательно писать weak, https://medium.com/@hhadevs/strong-unowned-weak-в-чем-разница-b293963f3375
            
            switch response.result {
            case .success(let value):
                if let responeValue = value as? [String : Any] {
                    if let responeFilms = responeValue["results"] as! [[String : Any]]? {
                        for film in responeFilms {
                            
                            let title = film["original_title"] as? String
                            let id = film["id"] as? Int
                            let poster = film["backdrop_path"] as? String
                            let language = film["original_language"] as? String
                            let overview = film["overview"] as? String
                            let vote = film["vote_average"] as? Double
                            let popular = film["popularity"] as? Double
                            
                            let film = Film(id: id!,
                                            overview: overview!,
                                            title: title!,
                                            language: language!,
                                            poster: poster!,
                                            popular: popular!,
                                            vote: vote!)
                            self.films.append(film)
                            self.view?.configureWith(model: .init(items: self.films))
                        }
                        
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.view?.hideActivityIndicator()
        }
    }
    
    func didSelectMovie(at index: Int) {
        let film = films[index]
        
        router?.showFilmDetails(film: film)
    }
    
}

// MARK: - FilmsControllerOutput

extension FilmsPresenter: FilmsControllerOutput {
    
    func viewDidLoad() {
        view?.showActivityIndicator()
        fetchFilms()
    }
    
}
