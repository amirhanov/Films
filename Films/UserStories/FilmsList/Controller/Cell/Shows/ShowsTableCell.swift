//
//  BannerTableCell.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 26.05.2021.
//

import UIKit
import SDWebImage

final class ShowsTableCell: UITableViewCell {
    
    // MARK:- Public Properties
    
    var shows = [TVShows]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK:- Private Properties
    
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private enum Constants {
        static let cellID = "cellID"
    }
    lazy private var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                         collectionViewLayout: collectionViewLayout)
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "cover")
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "Popular and new series of various services such as Netflix, Okko and others."
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let subscriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "Trial subscription"
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "7 days free, then USD 19.00 per week"
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        setupStackView()
        setupCollectionView()
        setupGradientLayer()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private Methods
    
    private func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(collectionView)
        addSubview(stackView)
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(subscriptionLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.setCustomSpacing(16, after: descriptionLabel)
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.frame = contentView.frame
        gradientLayer.locations = [0, 1]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        backgroundImageView.addSubview(gradientView)
        backgroundImageView.bringSubviewToFront(gradientView)
        backgroundImageView.frame = contentView.frame
    }
    
    private func setupCollectionView() {
        collectionViewLayout.scrollDirection = .horizontal
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ShowsCollectionCell.self, forCellWithReuseIdentifier: Constants.cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -8),
            
            collectionView.heightAnchor.constraint(equalToConstant: 153),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK:- UICollectionViewDataSource

extension ShowsTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as! ShowsCollectionCell
        let model = shows[indexPath.row]
        
        cell.configureShowsWith(withModel: model)
        
        return cell
    }
}

// MARK:- UICollectionViewDelegateFlowLayout

extension ShowsTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 137)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
}

// MARK:- UICollectionViewDelegate

extension ShowsTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
