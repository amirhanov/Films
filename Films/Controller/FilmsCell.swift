//
//  FilmsCell.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 06.04.2021.
//

import UIKit

class FilmsCell: UITableViewCell {
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.layer.cornerRadius = 10
        }
    }
}
