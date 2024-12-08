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
        // Meal Image
        let imageView = UIImageView()
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

        // Meal Title
        let titleLabel = UILabel()
        titleLabel.text = meal.strMeal
        titleLabel.font =  UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Meal Area (Badge)
        let areaBadge = UILabel()
        areaBadge.text = meal.strArea
        areaBadge.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        areaBadge.textAlignment = .center
        areaBadge.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        areaBadge.layer.cornerRadius = 16
        areaBadge.clipsToBounds = true
        areaBadge.translatesAutoresizingMaskIntoConstraints = false

        // Scroll View for Ingredients and Instructions
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Ingredients Section
        let ingredientsLabel = UILabel()
        ingredientsLabel.text = "Ingredients"
        ingredientsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false

        let ingredientsContent = UILabel()
        ingredientsContent.text = meal.ingredients.joined(separator: "\n")
        ingredientsContent.font = UIFont.systemFont(ofSize: 16)
        ingredientsContent.numberOfLines = 0
        ingredientsContent.translatesAutoresizingMaskIntoConstraints = false

        // Instructions Section
        let instructionsLabel = UILabel()
        instructionsLabel.text = "Instructions"
        instructionsLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false

        let instructionsContent = UILabel()
        instructionsContent.text = meal.strInstructions
        instructionsContent.font = UIFont.systemFont(ofSize: 16)
        instructionsContent.numberOfLines = 0
        instructionsContent.translatesAutoresizingMaskIntoConstraints = false

        // YouTube Link Section
        let youtubeLabel = UILabel()
        youtubeLabel.text = "Available on YouTube"
        youtubeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        youtubeLabel.translatesAutoresizingMaskIntoConstraints = false

        let youtubeButton = UIButton(type: .system)
        youtubeButton.setTitle("Watch Tutorial", for: .normal)
        youtubeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        youtubeButton.addTarget(self, action: #selector(openYouTube), for: .touchUpInside)
        youtubeButton.translatesAutoresizingMaskIntoConstraints = false

        // Add Subviews
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(areaBadge)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(ingredientsContent)
        contentView.addSubview(instructionsLabel)
        contentView.addSubview(instructionsContent)
        contentView.addSubview(youtubeLabel)
        contentView.addSubview(youtubeButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            areaBadge.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            areaBadge.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            areaBadge.widthAnchor.constraint(equalToConstant: 100),
            areaBadge.heightAnchor.constraint(equalToConstant: 32),

            scrollView.topAnchor.constraint(equalTo: areaBadge.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            ingredientsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            ingredientsContent.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 8),
            ingredientsContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            instructionsLabel.topAnchor.constraint(equalTo: ingredientsContent.bottomAnchor, constant: 16),
            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            instructionsContent.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 8),
            instructionsContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            instructionsContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            youtubeLabel.topAnchor.constraint(equalTo: instructionsContent.bottomAnchor, constant: 16),
            youtubeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            youtubeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            youtubeButton.topAnchor.constraint(equalTo: youtubeLabel.bottomAnchor, constant: 8),
            youtubeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            youtubeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            youtubeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    @objc private func openYouTube() {
        guard let url = URL(string: meal.strYoutube ?? "") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
