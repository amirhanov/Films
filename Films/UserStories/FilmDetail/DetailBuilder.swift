//
//  DetailBuilder.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 05.05.2021.
//

import Foundation

extension AssemblyBuilder {
    func createDetail() -> DetailController {
        let controller = DetailController()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        let network = NetworkService()
        
        presenter.view = controller
        presenter.router = router
        presenter.network = network
        controller.output = presenter
        
        return controller
    }
}
