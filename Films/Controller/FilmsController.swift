//
//  ViewController.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 05.04.2021.
//

import UIKit
import Alamofire
import SDWebImage

class FilmsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "cellID"
    
    var films: [Film] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFilms()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    //MARK:- Setup NavigationBar
    
    func setupNavigationBar() {
        title = "Home"
    }
    
    //MARK:- Setup TableView
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK:- Fetch Films
    
    func fetchFilms() {
        let apiKey = "67e0511a3fe36e56041dc931db60f810"
        let page = 1
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
                            
                            let film = Film(id: id!, overview: overview!, title: title!, language: language!, poster: poster!, popular: popular!, vote: vote!)
                            films.append(film)
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

//MARK:- Setup TableView Protocols

extension FilmsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if films.count != 0 {
            return films.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? FilmsCell else { return UITableViewCell() }
        let section = films[indexPath.row]
        
        cell.rateLabel.text = "Rate: \(section.vote)"
        cell.titleLabel.text = section.title
        cell.languageLabel.text = "Language: \(section.language)"
        cell.posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(section.poster)"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
