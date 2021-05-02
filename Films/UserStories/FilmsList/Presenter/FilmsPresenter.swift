//
//  FilmsPresenter.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import Foundation

protocol FilmsViewProtocol: class {
    func success()
    func failure(error: Error)
}

protocol FilmsViewPresenterProtocol: class {
    init(view: FilmsViewProtocol, network: NetworkServiceProtocol, router: FilmsRouterProtocol)
    
    var films: [Films]? { get set }
    
    func getFilms()
    func tapOnTheFilm(film: Films?)
}

class FilmsPresenter: FilmsViewPresenterProtocol {
    weak var view: FilmsViewProtocol?
    var router: FilmsRouterProtocol?
    let network: NetworkServiceProtocol!
    var films: [Films]?
    
    required init(view: FilmsViewProtocol, network: NetworkServiceProtocol, router: FilmsRouterProtocol) {
        self.view = view
        self.network = network
        self.router = router
        getFilms()
    }
    
    func getFilms() {
        network.getFilms { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let films):
                    self.films = films
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func tapOnTheFilm(film: Films?) {
        router?.showDetailController(films: film)
    }
}
