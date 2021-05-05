//
//  DetailController.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit
import SDWebImage

struct DetailControllerViewModel {
    let item: Film
}

protocol DetailControllerInput: AnyObject {
    func hideActivityIndicator()
    func showActivityIndicator()
    func configureWith(model: DetailControllerViewModel)
}

class DetailController: UIViewController {
    
    // MARK: - Public Properties
    
    var output: DetailControllerOutput!
    var films: Films?
    var id: Int?

    // MARK: - Private Properties
    
    private var film: Film?
    private let activityIndicatorView = UIActivityIndicatorView()
    private let gradientLayer = CAGradientLayer()
    private let gradientView = UIView()
    private let colorTop = UIColor.clear.cgColor
    private let colorBottom = UIColor.black.cgColor
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let watchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Смотреть бесплатная версию", for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.imageEdgeInsets.left = -16
        button.contentEdgeInsets.left = 16
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Подписка", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
        return  label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.text = "7 дн. бесплатно, затем 199,00 ₽ в неделю"
        label.numberOfLines = 1
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 3
        return label
    }()
    
    private let spaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let spaceeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
        output.viewDidLoad(id: id!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        restoreSetupNavigationBar()
    }
    
    // MARK:- Init
    
    private func commonInit() {
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.frame = view.bounds
        gradientLayer.locations = [0, 1]
        gradientView.frame = backgroundImageView.frame
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(backgroundImageView)
        view.addSubview(priceLabel)
        view.addSubview(overviewLabel)
        view.addSubview(watchButton)
        view.addSubview(subscribeButton)
        
        backgroundImageView.addSubview(gradientView)
        backgroundImageView.bringSubviewToFront(gradientView)
        backgroundImageView.frame = view.frame
        
        let mainStackView = UIStackView(arrangedSubviews: [
            taglineLabel,
            titleLabel,
            detailLabel,
            watchButton,
            subscribeButton,
            priceLabel,
            overviewLabel
        ])
        
        mainStackView.setCustomSpacing(24, after: detailLabel)
        mainStackView.setCustomSpacing(24, after: priceLabel)
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.axis = .vertical
        mainStackView.spacing = 6
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            watchButton.heightAnchor.constraint(equalToConstant: 44),
            subscribeButton.heightAnchor.constraint(equalToConstant: 44),
            
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK:- Private Methods
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem?.title = ""
    }
    
    private func restoreSetupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
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

// MARK:- DetailControllerInput

extension DetailController: DetailControllerInput {
    func hideActivityIndicator() {
        stopActivityIndicator()
    }
    
    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }
    
    func configureWith(model: DetailControllerViewModel) {
        film = model.item
        
        detailLabel.text = "Создан \(film!.release_date) • \(film!.runtime) мин. • Apple TV"
        taglineLabel.text = film?.tagline
        overviewLabel.text = film?.overview
        titleLabel.text = film?.original_title
        backgroundImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(film!.poster_path)"))
    }
}
