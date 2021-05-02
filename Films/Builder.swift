//
//  Builder.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import Foundation

protocol AssemblyBuilderProtocol {
    func createMain(router: FilmsRouterProtocol) -> UIViewController
    func createDetail(router: FilmsRouterProtocol, films: Films?) -> UIViewController
}

class AssemblyModelBuilder: AssemblyBuilderProtocol {
    func createMain(router: FilmsRouterProtocol) -> UIViewController {
        let view = FilmsController()
        let network = NetworkService()
        let presenter = FilmsPresenter(view: view, network: network, router: router)
        
        view.presenter = presenter
        
        return view
    }
    
    func createDetail(router: FilmsRouterProtocol, films: Films?) -> UIViewController {
        let view = DetailController()
        let network = NetworkService()
        let presenter = DetailPresenter(view: view, network: network, router: router, films: films)
        
        view.presenter = presenter
        
        return view
    }
}
