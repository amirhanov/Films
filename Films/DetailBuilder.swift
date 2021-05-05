//
//  DetailBuilder.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 04.05.2021.
//

import Foundation

extension AssemblyBuilder {
    func createDetail() -> DetailController {
        let controller = DetailController()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        
        presenter.view = controller
        presenter.router = router
        controller.output = presenter
        
        return controller
    }
}
