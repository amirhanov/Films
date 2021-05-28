//
//  ShowsCollectionCell.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 27.05.2021.
//

import UIKit

class ShowsCollectionCell: UICollectionViewCell {
    
    //MARK:- Private Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.12).cgColor
        imageView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        addSubviews()
        addConstraints()
    }
    
    // MARK: - Public Methods
    
    func configureShowsWith(withModel model: TVShows) {
        titleLabel.text = model.name
        posterImageView.sd_setImage(with: URL(string: model.backdrop_path))
    }
    
    // MARK:- Private Methods
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(posterImageView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 94),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
}
