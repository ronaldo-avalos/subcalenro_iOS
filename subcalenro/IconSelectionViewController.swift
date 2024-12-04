//
//  IconSelectionViewController.swift
//  subcalenro
//
//  Created by Ronaldo Avalos on 04/12/24.
//

import Foundation
import UIKit

class IconSelectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Nombres de los iconos en Assets.xcassets
    let iconNames: [String] = ["icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8","icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8","icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8","icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8","icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8","icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8","icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8","icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8","icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8","icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8"]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        self.title = "Select Icon"
        self.navigationController?.navigationBar.tintColor = ThemeManager.color(for: .primaryText)
        
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.identifier, for: indexPath) as? IconCell else {
            return UICollectionViewCell()
        }
        let iconName = iconNames[indexPath.item]
        cell.configure(with: iconName)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 5 // 3 columnas con padding de 10
        return CGSize(width: width, height: width)
    }
}

// MARK: - IconCell
class IconCell: UICollectionViewCell {
    static let identifier = "IconCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ])
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with iconName: String) {
        imageView.image = UIImage(named: iconName)
    }
}
