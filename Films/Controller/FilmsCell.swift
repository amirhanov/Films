//
//  FilmsCell.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 12.04.2021.
//

import UIKit
import SDWebImage

class FilmsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableViewCell()
    }
    
    // MARK: - Private Methods
    
    private func setupTableViewCell() {
        titleLabel.numberOfLines = 2
        languageLabel.numberOfLines = 1
        rateLabel.numberOfLines = 1
        posterImageView.layer.cornerRadius = 10
    }
    
    private func startActivityIndicator() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    func configureWith(withModel model: Film) {
        titleLabel.text = model.title
        languageLabel.text = "Language: \(model.language)"
        rateLabel.text = "Rate: \(model.vote))"
        
        posterImageView.sd_setImage(with: URL(string: model.poster)) { (image, error, cache, url) in
            if (error != nil) {
                self.startActivityIndicator()
            } else {
                self.posterImageView.image = image
                self.stopActivityIndicator()
            }
        }
    }
}
