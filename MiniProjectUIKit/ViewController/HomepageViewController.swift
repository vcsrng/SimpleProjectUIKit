//
//  HomepageViewController.swift
//  MiniProjectUIKit
//
//  Created by Vincent Saranang on 06/12/24.
//

import UIKit

class HomepageViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let searchBar = UISearchBar()
    let filterScrollView = UIScrollView()
    var collectionView: UICollectionView!
    let titleLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var areas: [String] = []
    var selectedFilters: Set<String> = []
    var meals: [Meal] = []
    var allMeals: [Meal] = []
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupUI()
        fetchAreas()
        fetchMeals(for: "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTitlePosition()
    }

    // Adjust the title's position based on safe area insets
    private func adjustTitlePosition() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = true
        titleLabel.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top - 32,
            width: view.frame.width,
            height: 30
        )
        titleLabel.textAlignment = .center
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Title
        titleLabel.accessibilityIdentifier = "TitleLabel"
        titleLabel.text = "Choose your menu"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.addSubview(titleLabel)
        
        // Search Bar
        searchBar.delegate = self
        searchBar.accessibilityIdentifier = "Search"
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal // Removes top and bottom lines
        searchBar.keyboardType = .default
        searchBar.returnKeyType = .search
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        // Gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Filter ScrollView
        filterScrollView.accessibilityIdentifier = "FilterScrollView"
        filterScrollView.showsHorizontalScrollIndicator = true
        view.addSubview(filterScrollView)
        
        filterScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
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
        
        collectionView.accessibilityIdentifier = "RecipeCollectionView"
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Fetch Areas for Filters
    private func fetchAreas() {
        startLoading()
        let urlString = "https://www.themealdb.com/api/json/v1/1/list.php?a=list"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.stopLoading() }
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(AreaResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.areas = response.meals.map { $0.strArea }
                        self.setupFilters()
                    }
                } catch {
                    print("Decoding error for areas: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func setupFilters() {
        filterScrollView.subviews.forEach { $0.removeFromSuperview() }
        
        var xOffset: CGFloat = 0
        xOffset += 16
        for area in areas {
            let button = UIButton(type: .system)
            button.setTitle(area, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray.cgColor
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            button.frame = CGRect(x: xOffset, y: 0, width: 100, height: 32)
            button.addTarget(self, action: #selector(toggleFilter(_:)), for: .touchUpInside)
            filterScrollView.addSubview(button)
            xOffset += 108
        }
        xOffset += 8
        filterScrollView.contentSize = CGSize(width: xOffset, height: 40)
    }
    
    // MARK: - Apply Combined Filters
    func applyFilters() {
        if selectedFilters.isEmpty && searchBar.text?.isEmpty == true {
            meals = allMeals
        } else {
            meals = allMeals.filter { meal in
                let matchesArea = selectedFilters.isEmpty || selectedFilters.contains(meal.strArea)
                let matchesSearch = (searchBar.text?.isEmpty ?? true) || meal.strMeal.lowercased().contains(searchBar.text!.lowercased())
                return matchesArea && matchesSearch
            }
        }
        collectionView.reloadData()
    }
    
    // MARK: - Fetch Meals with Area Filter
    private func fetchMeals(for keyword: String) {
        startLoading()
        let urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(keyword)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.stopLoading() }
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(MealsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.allMeals = response.meals ?? []
                        self.applyFilters()
                    }
                } catch {
                    print("Decoding error for meals: \(error)")
                }
            }
        }
        task.resume()
    }

    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchMeals(for: "")
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else {
            meals = allMeals
            collectionView.reloadData()
            return
        }
        fetchMeals(for: keyword)
        searchBar.resignFirstResponder()
    }

    // MARK: - Toggle Filter Button
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

    
    // MARK: - Loading State
    private func startLoading() {
        isLoading = true
        activityIndicator.startAnimating()
        collectionView.isHidden = true
    }
    
    private func stopLoading() {
        DispatchQueue.main.async {
            self.isLoading = false
            self.activityIndicator.stopAnimating()
            self.collectionView.isHidden = false
        }
    }
    
    // MARK: - Dismiss Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
        let width = (view.frame.width / (UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2)) - 24
        let height = (view.frame.height * 0.3) - 16
        return CGSize(width: width, height: height)
    }
}
