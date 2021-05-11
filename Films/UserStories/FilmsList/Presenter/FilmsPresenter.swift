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
}

// MARK:- FilmsControllerOutput

extension FilmsPresenter: FilmsControllerOutput {
    func viewDidLoad() {
        view?.showActivityIndicator()
        fetchFilms()
    }
    
    func didSelectMovie(index: Int) {
        let film = films[index]
        router?.showFilmDetails(film: film)
    }
}
