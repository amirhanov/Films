//
//  ViewController.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 05.04.2021.
//

import UIKit
import SDWebImage

struct FilmsControllerViewModel {
    let items: [Films]
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
    
    private var refreshControl = UIRefreshControl()
    private let cellID = "cellID"
    private let activityIndicatorView = UIActivityIndicatorView()
    private let tableView = UITableView()
    private var films = [Films]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewDidLoad()
        
        setupTableVIew()
        setupNavigationBar()
        setupRefreshControl()
        setupActivityIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK:- Private Methods
    
    private func setupRefreshControl() {
        let attributedTitle = NSAttributedString(string: "Потяни меня вниз")
        
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(pool), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
    }
    
    @objc func pool() {
        output.viewDidLoad()
        refreshControl.endRefreshing()
    }
    
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
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FilmsCell
        let model = films[indexPath.row]
        
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
        
        let assemblyBuilder = AssemblyBuilder()
        let detailController = assemblyBuilder.createDetail()
        detailController.id = films[indexPath.row].id
        navigationController?.pushViewController(detailController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- FilmsControllerInput

extension FilmsController: FilmsControllerInput {
    func hideActivityIndicator() {
        stopActivityIndicator()
    }
    
    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }
    
    func configureWith(model: FilmsControllerViewModel) {
        films = model.items
    }
}

/*
 Заметка:
 
 1. Порядок свойств: Public properties, Private properties, Init, Public method, Private method, Extension.

*/
