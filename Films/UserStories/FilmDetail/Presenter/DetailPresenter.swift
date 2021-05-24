//
//  DetailPresenter.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import Alamofire

protocol DetailControllerOutput: AnyObject {
    func viewDidLoad()
}

class DetailPresenter {
    
    // MARK: - Public Properties
    
    weak var view: DetailControllerInput?
    var router: DetailRouterInput?
    var network: NetworkServiceProtocol!
    
    // MARK:  - Private Properties
    
    private var film: Film?
    private var filmID: Int
    
    // MARK:- Init
    
    init(filmID: Int) {
        self.filmID = filmID
    }
    
    // MARK: - Private Methods
    
    private func fetchDetail() {
        network.getDetailForFilm(id: filmID) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self.film = detail!
                    self.view?.configureWith(model: .init(item: self.film!))
                case .failure(let error):
                    print(error.localizedDescription) // TODO: - Давай добавим обработку ошибок, будем показывать UIAlertController с текстом ошибки P.S. работу можно проверить просто запихнув в сакссесс с дефолтным текстом 
                }
                self.view?.hideActivityIndicator()
            }
        }
    }
}

// MARK: - DetailControllerOutput

extension DetailPresenter: DetailControllerOutput {
    func viewDidLoad() {
        view?.showActivityIndicator()
        fetchDetail()
    }
}
