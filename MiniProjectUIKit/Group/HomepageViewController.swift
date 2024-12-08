//
//  HomepageViewController.swift
//  MiniProjectUIKit
//
//  Created by Vincent Saranang on 06/12/24.
//

import UIKit

class HomepageViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let searchBar = UISearchBar()
    private let filterScrollView = UIScrollView()
    private var collectionView: UICollectionView!
    private let titleLabel = UILabel()
    
    private var areas: [String] = [] // Dynamic areas from the API
    private var selectedFilters: Set<String> = []
    private var meals: [Meal] = [] // Filtered meals to display
    private var allMeals: [Meal] = [] // All meals fetched from the API
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchAreas() // Fetch areas dynamically from the API
        fetchMeals(for: "") // Fetch all meals initially
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Title
        titleLabel.text = "Choose your menu"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Search Bar
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Add gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allows other touches to be recognized
        view.addGestureRecognizer(tapGesture)

        // Filter ScrollView
        filterScrollView.showsHorizontalScrollIndicator = true
        view.addSubview(filterScrollView)
        
        filterScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            filterScrollView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Collection View
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeCell")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Fetch Areas for Filters
    private func fetchAreas() {
        let urlString = "https://www.themealdb.com/api/json/v1/1/list.php?a=list"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(AreaResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.areas = response.meals.map { $0.strArea } // Extract areas
                        self.setupFilters() // Dynamically create filter buttons
                    }
                } catch {
                    print("Decoding error for areas: \(error)")
                }
            }
        }
        task.resume()
    }
    
    private func setupFilters() {
        filterScrollView.subviews.forEach { $0.removeFromSuperview() } // Clear existing buttons
        
        var xOffset: CGFloat = 0
        for area in areas {
            let button = UIButton(type: .system)
            button.setTitle(area, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray.cgColor
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            button.frame = CGRect(x: xOffset, y: 0, width: 100, height: 32) // Adjust width for longer names
            button.addTarget(self, action: #selector(toggleFilter(_:)), for: .touchUpInside)
            filterScrollView.addSubview(button)
            xOffset += 108 // Width + Spacing
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
        
        applyFilters()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func applyFilters() {
        if selectedFilters.isEmpty {
            meals = allMeals
        } else {
            meals = allMeals.filter { meal in
                selectedFilters.contains(meal.strArea)
            }
        }
        
        collectionView.reloadData()
    }
    
    // MARK: - Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else {
            return
        }
        
        // Trigger your search logic here
        fetchMeals(for: keyword)
        
        // Dismiss keyboard
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Network Call for Meals
    private func fetchMeals(for keyword: String) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(keyword)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(MealsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.allMeals = response.meals ?? [] // Store all fetched meals
                        self.meals = self.allMeals // Show all meals initially
                        self.collectionView.reloadData()
                    }
                } catch {
                    print("Decoding error for meals: \(error)")
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCollectionViewCell
        let meal = meals[indexPath.row]
        cell.configure(with: meal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        let detailVC = DetailMenuViewController(meal: meal)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Collection View Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 2) - 24
        let height = (view.frame.height * 0.3) - 16
        return CGSize(width: width, height: height)
    }
}
