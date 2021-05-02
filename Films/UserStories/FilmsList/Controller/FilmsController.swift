//
//  ViewController.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 05.04.2021.
//

import UIKit
import SDWebImage

class FilmsController: UIViewController {
    
    // MARK: - Private Properties
    
    private let cellID = "cellID"
    private let activityIndicatorView = UIActivityIndicatorView()
    private let tableView = UITableView()
    
    // MARK:- Public Properties
    
    var presenter: FilmsViewPresenterProtocol!

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        tableView.register(FilmsCell.self, forCellReuseIdentifier: cellID)
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
        
        activityIndicatorView.startAnimating()
    }
    
    private func stopActivityIndicator() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
}

// MARK:- UITableViewDataSource

extension FilmsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.films?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FilmsCell
        let model = presenter.films![indexPath.row]
        
        cell.configureWith(withModel: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

// MARK:- UITableViewDelegate

extension FilmsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = presenter.films?[indexPath.row]
        
        presenter.tapOnTheFilm(film: film)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- FilmsViewProtocol

extension FilmsController: FilmsViewProtocol {
    func success() {
        stopActivityIndicator()
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

/*
 Заметка:
 
 1. Порядок свойств: Public properties, Private properties, Init, Public method, Private method, Extension.

*/
