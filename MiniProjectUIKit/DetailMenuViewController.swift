//
//  DetailMenuViewController.swift
//  MiniProjectUIKit
//
//  Created by Vincent Saranang on 06/12/24.
//

import UIKit

class DetailMenuViewController: UIViewController {
    private let meal: Meal

    init(meal: Meal) {
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        let imageView = UIImageView()
        let titleLabel = UILabel()
        let areaLabel = UILabel()
        let instructionLabel = UILabel()
        
        // Configure Views
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = URL(string: meal.strMealThumb) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        titleLabel.text = meal.strMeal
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        areaLabel.text = "Area: \(meal.strArea)"
        instructionLabel.text = meal.strInstructions
        instructionLabel.numberOfLines = 0
        
        // Layout
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(areaLabel)
        view.addSubview(instructionLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            areaLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            areaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            areaLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            instructionLabel.topAnchor.constraint(equalTo: areaLabel.bottomAnchor, constant: 16),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
