//
//  FilmsCell.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 12.04.2021.
//

import UIKit
import SDWebImage

// TODO: - еще я не говорил, но если у тебя от класс не будет никто наследоваться то лучше добавлять final, это ускоряет работу приложения
class FilmsTableCell: UITableViewCell {
    
    // MARK:- Public Properties
    
    // TODO: - delegate должен быть сдабой ссылкой иначе будет retain cycle
    var passDelegate: PassDataFromCollectionView?
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
    lazy private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // TODO: - Перенечсти setup из layoutSubviews
    }
    
    override func layoutSubviews() {
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Private Methods
    
    private func setupView() {
        // TODO: - Разбить на отдельные методы: setupCollectionView, addSubviews и configureConstraints и уже эти методы добавить в setup. Старайся везде придерживаться такой практики. Функция должна выполнять одну единственную цель.
        collectionViewLayout.scrollDirection = .horizontal
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FimsCollectionCell.self, forCellWithReuseIdentifier: Constants.cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - UICollectionViewDataSource

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
