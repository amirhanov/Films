//
//  FilmsCell.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 12.04.2021.
//

import UIKit
import SDWebImage

class FilmsCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let rateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let languageLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let posterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() { // MARK: - не вызывается если верстаем кодом,  надо убрать
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configureWith(withModel model: Film) {
        titleLabel.text = model.title
        languageLabel.text = "Language: \(model.language)"
        rateLabel.text = "Rate: \(model.vote)"
        
        posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(model.poster)")) { (image, error, cache, url) in
            if (error != nil) {
                
            } else {
                self.posterImageView.image = image
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() { // Давай вынесем в отдельные методы : func addSubviews() , setupStackViews(), setupContraints()
        
        contentView.addSubview(posterImageView)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            languageLabel,
            rateLabel
        ])
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 2
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 140),
            posterImageView.heightAnchor.constraint(equalToConstant: 80),
            
            stackView.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
