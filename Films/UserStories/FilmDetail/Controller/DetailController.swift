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

    // MARK: - Private Properties
    
    private var film: Film?
    private let tableView = UITableView()
    private let activityIndicatorView = UIActivityIndicatorView()
    private let gradientLayer = CAGradientLayer()
    private let gradientView = UIView()
    private let colorTop = UIColor.clear.cgColor
    private let colorBottom = UIColor.black.cgColor
    
    private enum Constants {
        static let cellID = "cellID"
        static let heightForRow: CGFloat = 48
    }
    
    private var backgroundImageView: UIImageView = {
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
        button.setTitle("Watch the free version", for: .normal)
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
        button.setTitle("Subscription", for: .normal)
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
        label.text = "7 days. free, then USD 19.00 per week"
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
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = false
        return view
    }()
    
    private let mainStackView = UIStackView()
    private let dateFormatter = DateFormatter()
    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        setupTableVIew()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreSetupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.frame = backgroundImageView.frame
    }
    
    // MARK:- Private Methods
    
    private func setupTableVIew() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = headerView
        tableView.insetsContentViewsToSafeArea = false
        tableView.contentInsetAdjustmentBehavior = .never
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        setupHeaderView()
    }
    
    private func setupNavigationBar() {
        title = nil
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share_outline_28"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(shareButtonTapped))
    }
    
    private func restoreSetupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
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
    
    private func setupHeaderView() {
        headerView.frame = view.frame
        
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.frame = headerView.bounds
        gradientLayer.locations = [0, 1]
        gradientView.frame = backgroundImageView.frame
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        headerView.addSubview(backgroundImageView)
        headerView.addSubview(priceLabel)
        headerView.addSubview(overviewLabel)
        headerView.addSubview(watchButton)
        headerView.addSubview(subscribeButton)
        
        backgroundImageView.addSubview(gradientView)
        backgroundImageView.bringSubviewToFront(gradientView)
        backgroundImageView.frame = headerView.frame
        
        mainStackView.addArrangedSubview(taglineLabel)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(detailLabel)
        mainStackView.addArrangedSubview(watchButton)
        mainStackView.addArrangedSubview(subscribeButton)
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(overviewLabel)
        mainStackView.setCustomSpacing(24, after: detailLabel)
        mainStackView.setCustomSpacing(24, after: priceLabel)
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.axis = .vertical
        mainStackView.spacing = 6
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            watchButton.heightAnchor.constraint(equalToConstant: 44),
            subscribeButton.heightAnchor.constraint(equalToConstant: 44),
            
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK:- OBJC Methods
    
    @objc private func shareButtonTapped() {
        let item = "Информация о фильме на сайте \(film!.homepage)"
        let activityController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        present(activityController, animated: true, completion: nil)
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
        
        detailLabel.text = "\(film!.genre) • \(film!.release_date)) • \(film!.runtime) мин."
        taglineLabel.text = film?.tagline
        overviewLabel.text = film?.overview
        titleLabel.text = film?.original_title
        backgroundImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(film!.poster_path)"))
    }
}

// MARK:- UITableViewDataSource

extension DetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        
        cell.textLabel?.text = "Ячейка номер: \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRow
    }
}

// MARK:- UITableViewDelegate

extension DetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- UIScrollViewDelegate

extension DetailController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let statusBarHeight: CGFloat = 44
        let navigationBarHeight: CGFloat = 44
        let headerHeight = (tableView.tableHeaderView?.frame.size.height)! - statusBarHeight - navigationBarHeight
        
        if offsetY < 0 {
            var transform = CATransform3DTranslate(CATransform3DIdentity, 0, offsetY, 0)
            let scaleFactor = 1 + (-1 * offsetY / (headerView.frame.size.height / 2))
            
            guard scaleFactor < 1.5 else { return }
            
            transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1)
            backgroundImageView.layer.transform = transform
        } else {
            mainStackView.alpha = 1 - (tableView.contentOffset.y / (tableView.contentSize.height - tableView.frame.size.height))
        }
        
        if offsetY < headerHeight {
            setupNavigationBar()
        } else {
            restoreSetupNavigationBar()
            title = film?.original_title
        }
    }
}

