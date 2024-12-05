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
        
        areaBadge.textAlignment = .center
        areaBadge.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        areaBadge.textColor = .white
        areaBadge.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        areaBadge.layer.cornerRadius = 12
        areaBadge.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            areaBadge.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            areaBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            areaBadge.widthAnchor.constraint(equalToConstant: 60),
            areaBadge.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with meal: Meal) {
        titleLabel.text = meal.strMeal
        areaBadge.text = meal.strArea
        if let url = URL(string: meal.strMealThumb) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
