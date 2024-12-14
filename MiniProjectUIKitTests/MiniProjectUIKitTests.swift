//
//  MiniProjectUIKitTests.swift
//  MiniProjectUIKitTests
//
//  Created by Vincent Saranang on 02/12/24.
//

import XCTest
@testable import MiniProjectUIKit

final class MiniProjectUIKitTests: XCTestCase {

    var sut: HomepageViewController! // System Under Test

    override func setUpWithError() throws {
        sut = HomepageViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testInitialSetup() throws {
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertEqual(sut.titleLabel.text, "Choose your menu")
        XCTAssertNotNil(sut.searchBar)
        XCTAssertNotNil(sut.filterScrollView)
        XCTAssertNotNil(sut.collectionView)
    }

    func testFetchAreasSuccess() throws {
        // Mock Data
        let mockData = """
        {
            "meals": [{"strArea": "Italian"}, {"strArea": "Mexican"}]
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(AreaResponse.self, from: mockData)
        sut.areas = response.meals.map { $0.strArea }
        sut.setupFilters()

        XCTAssertEqual(sut.areas.count, 2)
        XCTAssertEqual(sut.areas, ["Italian", "Mexican"])
        XCTAssertNotNil(sut.filterScrollView.subviews.first) // Check filter buttons added
    }

    func testFetchMealsSuccess() throws {
        // Simulate API response
        let apiResponse = """
        {
            "meals": [
                {"strMeal": "Chicken Curry", "strArea": "Indian", "strMealThumb": "https://www.example.com/image1.jpg", "strInstructions": "Cook chicken...", "strYoutube": "https://youtube.com"},
                {"strMeal": "Tacos", "strArea": "Mexican", "strMealThumb": "https://www.example.com/image2.jpg", "strInstructions": "Cook beef...", "strYoutube": null}
            ]
        }
        """
        let mockData = apiResponse.data(using: .utf8)!
        let response = try JSONDecoder().decode(MealsResponse.self, from: mockData)
        
        sut.allMeals = response.meals ?? []
        sut.applyFilters()
        
        XCTAssertEqual(sut.allMeals.count, 2)
        XCTAssertEqual(sut.meals.count, 2)
        XCTAssertEqual(sut.meals.first?.strMeal, "Chicken Curry")
    }

    func testApplyFilters() {
        // Create mock meals with all required properties
        let mockMeals = [
            Meal(
                strMeal: "Chicken Curry",
                strArea: "Indian",
                strMealThumb: "https://www.example.com/image1.jpg",
                strInstructions: "Cook chicken...",
                strYoutube: "https://www.youtube.com/watch?v=12345",
                strIngredient1: "Chicken",
                strIngredient2: "Onion",
                strIngredient3: "Tomato",
                strIngredient4: nil,
                strIngredient5: nil,
                strIngredient6: nil,
                strIngredient7: nil,
                strIngredient8: nil,
                strIngredient9: nil,
                strIngredient10: nil,
                strIngredient11: nil,
                strIngredient12: nil,
                strIngredient13: nil,
                strIngredient14: nil,
                strIngredient15: nil,
                strIngredient16: nil,
                strIngredient17: nil,
                strIngredient18: nil,
                strIngredient19: nil,
                strIngredient20: nil,
                strMeasure1: "1 kg",
                strMeasure2: "2 pieces",
                strMeasure3: "3 cups",
                strMeasure4: nil,
                strMeasure5: nil,
                strMeasure6: nil,
                strMeasure7: nil,
                strMeasure8: nil,
                strMeasure9: nil,
                strMeasure10: nil,
                strMeasure11: nil,
                strMeasure12: nil,
                strMeasure13: nil,
                strMeasure14: nil,
                strMeasure15: nil,
                strMeasure16: nil,
                strMeasure17: nil,
                strMeasure18: nil,
                strMeasure19: nil,
                strMeasure20: nil
            ),
            Meal(
                strMeal: "Tacos",
                strArea: "Mexican",
                strMealThumb: "https://www.example.com/image2.jpg",
                strInstructions: "Cook beef...",
                strYoutube: nil,
                strIngredient1: "Beef",
                strIngredient2: "Taco shells",
                strIngredient3: "Cheese",
                strIngredient4: nil,
                strIngredient5: nil,
                strIngredient6: nil,
                strIngredient7: nil,
                strIngredient8: nil,
                strIngredient9: nil,
                strIngredient10: nil,
                strIngredient11: nil,
                strIngredient12: nil,
                strIngredient13: nil,
                strIngredient14: nil,
                strIngredient15: nil,
                strIngredient16: nil,
                strIngredient17: nil,
                strIngredient18: nil,
                strIngredient19: nil,
                strIngredient20: nil,
                strMeasure1: "500 g",
                strMeasure2: "6 pieces",
                strMeasure3: "1 cup",
                strMeasure4: nil,
                strMeasure5: nil,
                strMeasure6: nil,
                strMeasure7: nil,
                strMeasure8: nil,
                strMeasure9: nil,
                strMeasure10: nil,
                strMeasure11: nil,
                strMeasure12: nil,
                strMeasure13: nil,
                strMeasure14: nil,
                strMeasure15: nil,
                strMeasure16: nil,
                strMeasure17: nil,
                strMeasure18: nil,
                strMeasure19: nil,
                strMeasure20: nil
            )
        ]

        // Assign mock meals to `allMeals`
        sut.allMeals = mockMeals

        // Apply a filter
        sut.selectedFilters = ["Indian"]
        sut.applyFilters()

        // Verify the filtered meals
        XCTAssertEqual(sut.meals.count, 1)
        XCTAssertEqual(sut.meals.first?.strMeal, "Chicken Curry")
    }
}
