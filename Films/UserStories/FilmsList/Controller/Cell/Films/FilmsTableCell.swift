//
//  FilmsCell.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 12.04.2021.
//

import UIKit
import SDWebImage

final class FilmsTableCell: UITableViewCell {
    
    // MARK:- Public Properties
    
    weak var passDelegate: PassDataFromCollectionView?
    var films = [Films]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK:- Private Properties

    private let collectionViewLayout = UICollectionViewFlowLayout()
    private enum Constants {
        static let cellID = "cellID"
    }
    lazy private var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                         collectionViewLayout: collectionViewLayout)
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        setupCollectionView()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private Methods
 
    private func addSubviews() {
        addSubview(collectionView)
    }
    
    private func setupCollectionView() {
        collectionViewLayout.scrollDirection = .horizontal
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FimsCollectionCell.self, forCellWithReuseIdentifier: Constants.cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK:- UICollectionViewDataSource

extension FilmsTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as! FimsCollectionCell
        let model = films[indexPath.row]
        
        cell.configureWith(withModel: model)
        
        return cell
    }
}

// MARK:- UICollectionViewDelegateFlowLayout

extension FilmsTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220, height: 231)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
}

// MARK:- UICollectionViewDelegate

extension FilmsTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        passDelegate?.didSelectMovie(index: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
