//
//  RecipeCollectionViewCell.swift
//  MiniProjectUIKit
//
//  Created by Vincent Saranang on 06/12/24.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let areaBadge = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupFrame()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(areaBadge)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        areaBadge.translatesAutoresizingMaskIntoConstraints = false
        
        // Image
        imageView.sizeToFit()
        
        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        // Area
        areaBadge.textAlignment = .center
        areaBadge.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        areaBadge.textColor = .black
        areaBadge.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        areaBadge.layer.cornerRadius = 12
        areaBadge.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            areaBadge.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            areaBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            areaBadge.widthAnchor.constraint(equalToConstant: 100),
            areaBadge.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupFrame() {
        // Add rounded corners
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        // Add border
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add color
        contentView.layer.backgroundColor = UIColor.white.cgColor

        // Add shadow to the cell
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }

    func configure(with meal: Meal) {
        titleLabel.text = meal.strMeal
        areaBadge.text = meal.strArea

        if let urlString = meal.strMealThumb, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        } else {
            self.imageView.image = UIImage(systemName: "photo")
        }
    }
}
