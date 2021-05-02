//
//  DetailController.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import SDWebImage

class DetailController: UIViewController {
    

    // MARK: - Private Properties
    
    private let backgroundImageView = UIImageView()
    private let watchButton = UIButton()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return  label
    }()
    
    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let adultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let imdbLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .orange
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let gradientLayer = CAGradientLayer()
    private let gradientView = UIView()
    let colorTop = UIColor.clear.cgColor
    let colorBottom = UIColor.black.cgColor
    
    // MARK:- Public Properties
    
    var presenter: DetailViewPresenterProtocol!
    var id: Int?
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.setFilm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreSetupNavigationBar()
    }
    
    // MARK:- Private Methods
    
    private func setupUI() {
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.frame = view.bounds
        gradientLayer.locations = [0, 1]
        gradientView.frame = backgroundImageView.frame
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(gradientView)
        backgroundImageView.bringSubviewToFront(gradientView)
        view.addSubview(watchButton)
        
        backgroundImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(presenter.films!.poster)"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.frame
        backgroundImageView.clipsToBounds = true
        
        watchButton.backgroundColor = .red
        watchButton.layer.cornerRadius = 10
        watchButton.setTitle("WATCH NOW", for: .normal)
        watchButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        
        rateLabel.text = "123"
        adultLabel.text = "18+"
        imdbLabel.text = "IMDb"
        releaseLabel.text = "123"
        
        let contentStackView = UIStackView(arrangedSubviews: [
            rateLabel,
            adultLabel,
            imdbLabel
        ])
        
        contentStackView.alignment = .center
        contentStackView.distribution = .fillProportionally
        contentStackView.axis = .horizontal
        contentStackView.spacing = 6
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            contentStackView,
            releaseLabel
        ])
        
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.axis = .vertical
        mainStackView.spacing = 6
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            watchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            watchButton.heightAnchor.constraint(equalToConstant: 56),
            watchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            mainStackView.bottomAnchor.constraint(equalTo: watchButton.topAnchor, constant: -24),
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    private func restoreSetupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
}

// MARK:- DetailViewProtocol

extension DetailController: DetailViewProtocol {
    func setFilm(films: Films?) {
        titleLabel.text = presenter.films?.title
    }
    
    func success() {
        
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}
