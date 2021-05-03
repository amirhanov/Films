//
//  DetailPresenter.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import Foundation

protocol DetailViewProtocol: AnyObject {
    func setFilm(films: Films?)
    func success()
    func failure(error: Error)
}

protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, network: NetworkServiceProtocol, router: FilmsRouterProtocol, films: Films?) // иницилизаторы не должны быть в протоколе
    
    var films: Films? { get set }
    var film: Film? { get set }
    
    func viewDidLoad()
}

class DetailPresenter  {
    
    // MARK: - Public Properties
    
    weak var view: DetailViewProtocol?
    var router: FilmsRouterProtocol?
    let network: NetworkServiceProtocol!
    var films: Films?
    var film: Film?
    
    // MARK: - Initializers
    
    // Презентер нужно собирать в ассембли
    required init(view: DetailViewProtocol, network: NetworkServiceProtocol, router: FilmsRouterProtocol, films: Films?) {
        self.view = view
        self.network = network
        self.films = films
        self.router = router
    }
    
}

// MARK: - DetailViewPresenterProtocol

extension DetailPresenter: DetailViewPresenterProtocol {
    
    func viewDidLoad() {
        // В этом месте надо сказать вьюзе чтобы она показала лоадер
        network.getDetailForFilm(id: films!.id) { [weak self] result in
            guard let self = self else { return }
            
            // А вот тут чтобы скрыла лоадер
            DispatchQueue.main.async {
                switch result {
                case .success(let film):
                    self.film = film //
                    self.view?.success()
                    self.view?.setFilm(films: self.films)
                        /* Вот тут фильм есть уже есть и ты можешь обновить вьюху. Это происходит потому что запрос в сеть происходит в бекгрануд потоке и после полчения ответа ты при помощи DispatchQueue.main.async асинхронно возвращаешься в main поток и обновляешь UI. Вот отличная статься обязательная к прочтению на эту тему https://habr.com/ru/post/320152/
                        */
                case .failure(let error):
                    self.view?.failure(error: error) // Или показать ошибку
                }
            }
        }
    }
    
}
