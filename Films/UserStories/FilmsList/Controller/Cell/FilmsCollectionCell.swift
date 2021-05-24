//
//  FilmsCollectionCell.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 09.05.2021.
//

import UIKit
import SDWebImage
import Foundation // TODO: - не смысла импортить Foundation если заипортил UIKit, он включает в себя Foundation

class FimsCollectionCell: UICollectionViewCell {
    
    // MARK:- Public Properties
    
    // TODO: - Private
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // TODO: - Private
    let rateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // TODO: - Private
    let overviewLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // TODO: - Private
    let posterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.12).cgColor
        imageView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        setupView()
    }
    
    // MARK: - Public Methods
    
    func configureWith(withModel model: Films) {
        rateLabel.text = "IMDb: \(model.vote)"
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        
        // TODO: - Вроде можно засетить картинку без комплишена, все равно ты не обрабатываешь результат
        posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(model.poster)")) { (image, error, cache, url) in
            if (error != nil) {

            } else {
                self.posterImageView.image = image
            }
        }
    }
    
    // MARK:- Private Methods
    
    private func setupView() {
        //   // TODO: - Разбить на отдельные методы: setupCollectionView, setupStackView, addSubviews и configureConstraints и уже эти методы добавить в setup. Старайся везде придерживаться такой практики. Функция должна выполнять одну единственную цель.
        addSubview(posterImageView)

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [
            rateLabel,
            titleLabel,
            overviewLabel
        ])

        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 124),
            
            stackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
}
