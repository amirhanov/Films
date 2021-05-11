//
//  Router.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 06.05.2021.
//

import UIKit
import Foundation

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initionalViewController()
    func showDetailController(id: Int?)
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initionalViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMain() else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showDetailController(id: Int?) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createDetail(id: id) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
}

