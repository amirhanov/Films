//
//  FilmsPresenter.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import Alamofire

protocol FilmsControllerOutput: AnyObject {
    func viewDidLoad()
    func didSelectMovie(index at: Int)
}

class FilmsPresenter {
    
    // MARK: - Public Properties
    
    weak var view: FilmsControllerInput?
    var router: FilmsRouter?
    var network: NetworkServiceProtocol!
    
    // MARK:  - Private Properties
    
    private var films = [Films]()
    private var shows = [TVShows]()

    // MARK: - Private Methods
    
    private func fetchFilms() {
        network.getFilms { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let films):
                    self.films = films!
                    self.view?.configureWith(model: .init(items: self.films))
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.view?.hideActivityIndicator()
            }
        }
    }
    
    private func fetchTVShows() {
        network.getTVShows { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let shows):
                    self.shows = shows!
                    self.view?.configureShowsWith(model: .init(items: self.shows))
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.view?.hideActivityIndicator()
            }
        }
    }
}

// MARK:- FilmsControllerOutput

extension FilmsPresenter: FilmsControllerOutput {
    func viewDidLoad() {
        view?.showActivityIndicator()
        fetchFilms()
        fetchTVShows()
    }
    
    func didSelectMovie(index: Int) {
        let film = films[index]
        router?.showFilmDetails(film: film)
    }
}
