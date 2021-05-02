//
//  DetailPresenter.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import Foundation

protocol DetailViewProtocol: class {
    func setFilm(films: Films?)
    func success()
    func failure(error: Error)
}

protocol DetailViewPresenterProtocol: class {
    init(view: DetailViewProtocol, network: NetworkServiceProtocol, router: FilmsRouterProtocol, films: Films?)
    
    var films: Films? { get set }
    var film: Film? { get set }
    
    func getDetail()
    func setFilm()
}

class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    var router: FilmsRouterProtocol?
    let network: NetworkServiceProtocol!
    var films: Films?
    var film: Film?
    
    required init(view: DetailViewProtocol, network: NetworkServiceProtocol, router: FilmsRouterProtocol, films: Films?) {
        self.view = view
        self.network = network
        self.films = films
        self.router = router
        getDetail()
    }
    
    func getDetail() {
        network.getDetailForFilm(id: films!.id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let film):
                    self.film = film
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func setFilm() {
        self.view?.setFilm(films: films)
    }
}
