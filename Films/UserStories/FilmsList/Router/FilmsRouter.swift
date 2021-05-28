//
//  FilmsRouter.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import Foundation

protocol FilmsRouterInput {
    func showFilmDetails(film: Films)
}

class FilmsRouter: FilmsRouterInput {

    weak var view: FilmsController?
    
    func showFilmDetails(film: Films) {
        let detailController = DetailBuilder().createDetail(id: film.id)
        detailController.hidesBottomBarWhenPushed = true
        view?.navigationController?.pushViewController(detailController, animated: true)
    }
}

