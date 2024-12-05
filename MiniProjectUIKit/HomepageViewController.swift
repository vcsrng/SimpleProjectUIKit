//
//  HomepageViewController.swift
//  MiniProjectUIKit
//
//  Created by Vincent Saranang on 06/12/24.
//

import UIKit

private let mockRecipes: [Meal] = [
    Meal(
        idMeal: "52795",
        strMeal: "Chicken Handi",
        strArea: "Indian",
        strMealThumb: "https://www.themealdb.com/images/media/meals/wyxwsp1486979827.jpg",
        strInstructions: "Take a large pot or wok, heat the oil, add sliced onion and fry them until golden."
    ),
    Meal(
        idMeal: "52956",
        strMeal: "Chicken Congee",
        strArea: "Chinese",
        strMealThumb: "https://www.themealdb.com/images/media/meals/1529446352.jpg",
        strInstructions: "In a bowl, add chicken, salt, white pepper, and ginger juice. Mix well and set aside."
    ),
    Meal(
        idMeal: "52831",
        strMeal: "Chicken Karaage",
        strArea: "Japanese",
        strMealThumb: "https://www.themealdb.com/images/media/meals/tyywsw1505930373.jpg",
        strInstructions: "Mix ginger, garlic, soy sauce, sake, and sugar. Marinate chicken for at least 1 hour."
    )
]

class HomepageViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let searchBar = UISearchBar()
    private let filterScrollView = UIScrollView()
    private var collectionView: UICollectionView!
    private let filters = ["Indian", "Chinese", "Japanese", "French", "Moroccan"]
    private var selectedFilters: Set<String> = []
    private var recipes: [Meal] = [] // Fetch data from the API

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchRecipes() // Initial fetch with no filter
    }
    
    private func setupUI() {
        // Search Bar
        searchBar.delegate = self
        searchBar.placeholder = "Search recipes"
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Filter ScrollView
        filterScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(filterScrollView)
        filterScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            filterScrollView.heightAnchor.constraint(equalToConstant: 40)
        ])
        setupFilters()
        
        // Collection View
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupFilters() {
        var xOffset: CGFloat = 0
        for filter in filters {
            let button = UIButton(type: .system)
            button.setTitle(filter, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray.cgColor
            button.setTitleColor(.black, for: .normal)
            button.frame = CGRect(x: xOffset, y: 0, width: 80, height: 32)
            button.tag = filters.firstIndex(of: filter) ?? 0
            button.addTarget(self, action: #selector(toggleFilter(_:)), for: .touchUpInside)
            filterScrollView.addSubview(button)
            xOffset += 88 // Width + Spacing
        }
        filterScrollView.contentSize = CGSize(width: xOffset, height: 40)
    }
    
    @objc private func toggleFilter(_ sender: UIButton) {
        guard let filter = sender.title(for: .normal) else { return }
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter)
            sender.backgroundColor = .white
        } else {
            selectedFilters.insert(filter)
            sender.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        }
        fetchRecipes() // Apply filtering logic
    }
    
    private func fetchRecipes() {
        // Mock or API-based logic to fetch recipes based on `selectedFilters`
        // Example:
        self.recipes = mockRecipes.filter { meal in
            selectedFilters.isEmpty || selectedFilters.contains(meal.strArea)
        }
        collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as? RecipeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let recipe = recipes[indexPath.item]
        cell.configure(with: recipe)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.item]
        let detailVC = DetailMenuViewController(meal: recipe)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Collection View Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 24) / 2 // Two columns with spacing
        return CGSize(width: width, height: width * 1.5) // Adjust aspect ratio as needed
    }
}
