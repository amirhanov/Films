//
//  ViewController.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 05.04.2021.
//

import UIKit
import Alamofire
import SDWebImage

struct FilmCellViewModel {
    
}

class FilmsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let bundle = Bundle.main
    private let cellID = "cellID"
    private let apiKey = "67e0511a3fe36e56041dc931db60f810"
    private let page = 1
    private let activityIndicatorView = UIActivityIndicatorView()
    
    private var films: [Film] = []

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFilms()
        setupTableView()
        setupNavigationBar()
        setupActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK:- Private Methods
    
    private func setupNavigationBar() {
        title = "Home"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
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

    private func fetchFilms() {
        let url = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&page=\(page)"
        AF.request(url).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                if let responeValue = value as? [String : Any] {
                    if let responeFilms = responeValue["results"] as! [[String : Any]]? {
                        
                        for film in responeFilms {
                            
                            let title = film["original_title"] as? String
                            let id = film["id"] as? Int
                            let poster = film["backdrop_path"] as? String
                            let language = film["original_language"] as? String
                            let overview = film["overview"] as? String
                            let vote = film["vote_average"] as? Double
                            let popular = film["popularity"] as? Double
                            
                            let film = Film(id: id!,
                                            overview: overview!,
                                            title: title!,
                                            language: language!,
                                            poster: poster!,
                                            popular: popular!,
                                            vote: vote!)
                            films.append(film)
                            stopActivityIndicator()
                            tableView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        let cell = bundle.loadNibNamed("FilmsCell", owner: self, options: nil)?.first as! FilmsCell
        
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


/*
 Заметка:
 
 1. Порядок свойств: Public properties, Private properties, Init, Public method, Private method, Extension.

*/
