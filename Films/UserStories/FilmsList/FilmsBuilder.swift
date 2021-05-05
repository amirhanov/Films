//
//  FilmsBuilder.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 05.05.2021.
//

import Foundation

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createMain() -> FilmsController {
        let controller = FilmsController()
        let presenter = FilmsPresenter()
        let router = FilmsRouter()
        let network = NetworkService()
        
        presenter.view = controller
        presenter.router = router
        presenter.network = network
        controller.output = presenter
        
        return controller
    }
}
