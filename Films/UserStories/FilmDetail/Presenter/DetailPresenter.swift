//
//  DetailPresenter.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import Alamofire

protocol DetailControllerOutput: AnyObject {
    func viewDidLoad(id: Int)
}

class DetailPresenter {
    
    // MARK: - Public Properties
    
    weak var view: DetailControllerInput?
    var router: DetailRouterInput?
    var network: NetworkServiceProtocol!
    
    // MARK:  - Private Properties
    
    private var film: Film?
    
    // MARK: - Private Methods
    
    private func fetchDetail(id: Int) {
        network.getDetailForFilm(id: id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self.film = detail!
                    self.view?.configureWith(model: .init(item: self.film!))
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.view?.hideActivityIndicator()
            }
        }
    }
}

// MARK: - DetailControllerOutput

extension DetailPresenter: DetailControllerOutput {
    func viewDidLoad(id: Int) {
        view?.showActivityIndicator()
        fetchDetail(id: id)
    }
}
