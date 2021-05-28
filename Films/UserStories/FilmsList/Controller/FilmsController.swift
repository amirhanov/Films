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

struct ShowsControllerViewModel {
    let items: [TVShows]
}

protocol FilmsControllerInput: AnyObject {
    func hideActivityIndicator()
    func showActivityIndicator()
    func configureWith(model: FilmsControllerViewModel)
    func configureShowsWith(model: ShowsControllerViewModel)
}

protocol PassDataFromCollectionView: AnyObject {
    func didSelectMovie(index at: Int)
}

class FilmsController: UIViewController{
    
    // MARK: - Public Properties

    var output: FilmsControllerOutput!
    
    // MARK: - Private Properties
    
    private var refreshControl = UIRefreshControl()
    private let activityIndicatorView = UIActivityIndicatorView()
    private let tableView = UITableView()
    
    private var films = [Films]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var shows = [TVShows]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private enum Constants {
        static let cellID = "cellID"
        static let bannerCellID = "bannerCellID"
        static let defaultCellID = "defaultCellID"
        static let filmsHeightForRow: CGFloat = 247
        static let bannerHeightForRow: CGFloat = 450
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        output.viewDidLoad()
        
        addSubviews()
        setupTableVIew()
        addConstraints()
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
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupTableVIew() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilmsTableCell.self, forCellReuseIdentifier: Constants.cellID)
        tableView.register(ShowsTableCell.self, forCellReuseIdentifier: Constants.bannerCellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 8))
    }
    
    private func addConstraints() {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as! FilmsTableCell
            
            cell.films = films
            cell.passDelegate = self
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bannerCellID, for: indexPath) as! ShowsTableCell
            
            cell.shows = shows
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return Constants.filmsHeightForRow
        case 1: return Constants.bannerHeightForRow
        default: return 0
        }
    }
}

// MARK:- UITableViewDelegate

extension FilmsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func configureShowsWith(model: ShowsControllerViewModel) {
        shows = model.items
    }
}

extension FilmsController: PassDataFromCollectionView {
    func didSelectMovie(index: Int) {
        output.didSelectMovie(index: index)
    }
}
