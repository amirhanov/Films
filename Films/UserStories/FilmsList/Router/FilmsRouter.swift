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
    // TODO: - добавь сюда weak view: ViewController, в твоем случае FilmsController и засеть его в ассембли
    
    func showFilmDetails(film: Films) {
        
    }
}
