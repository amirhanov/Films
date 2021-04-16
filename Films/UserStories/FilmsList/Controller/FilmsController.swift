//
//  ViewController.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 05.04.2021.
//

import UIKit
import Alamofire
import SDWebImage

struct FilmsControllerViewModel {
    let items: [Film]
}

protocol FilmsControllerInput: AnyObject {
    func hideActivityIndicator()
    func showActivityIndicator()
    func configureWith(model: FilmsControllerViewModel)
}

class FilmsController: UIViewController {
    
    // MARK: - Public Properties
    
    var output: FilmsControllerOutput!
    
    // MARK: - Private Properties
    
    private let activityIndicatorView = UIActivityIndicatorView()
    private let tableView = UITableView()
    private var films = [Film]() {
        didSet { tableView.reloadData() }
    }
    
    private enum Constants {
        static let cellID = "cellID"
    }

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewDidLoad()
        setupTableVIew()
        setupNavigationBar()
        setupActivityIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK:- Private Methods
    
    private func setupTableVIew() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilmsCell.self, forCellReuseIdentifier: Constants.cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Home"
    }
    
    private func setupActivityIndicator() {
        activityIndicatorView.style = .medium
        activityIndicatorView.center = view.center
        
        view.addSubview(activityIndicatorView)
    }
    
    private func stopActivityIndicator() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }

}

// MARK:- UITableViewDelegate, UITableViewDataSource

extension FilmsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if films.count != 0 {
            return films.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as! FilmsCell
        
        cell.configureWith(withModel: films[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

// MARK: - FilmsControllerInput

extension FilmsController: FilmsControllerInput {
    
    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        stopActivityIndicator()
    }
    
    func configureWith(model: FilmsControllerViewModel) {
        films = model.items
    }
    
}


/*
 Заметка:
 
 1. Порядок свойств: Public properties, Private properties, Init, Public method, Private method, Extension.

*/
