//
//  FilmsRouter.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import Foundation

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol FilmsRouterProtocol: RouterMain {
    func initionalViewController()
    func showDetailController(films: Films?)
}

class Router: FilmsRouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initionalViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMain(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showDetailController(films: Films?) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createDetail(router: self, films: films) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
}
