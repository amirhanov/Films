//
//  FilmsAssembly.swift
//  Films
//
//  Created by MOrlov on 16.04.2021.
//

import Foundation

class FilmsAssembly {
    
    func configureModule() -> FilmsController {
        let controller = FilmsController()
        
        let presenter = FilmsPresenter()
        let router = FilmsRouter()
        
        presenter.view = controller
        presenter.router = router
        controller.output = presenter
        
        return controller
    }
    
}
