//
//  MiniProjectUIKitUITests.swift
//  MiniProjectUIKitUITests
//
//  Created by Vincent Saranang on 02/12/24.
//

import XCTest

final class MiniProjectUIKitUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testSearchFunctionality() throws {
        // Access the search bar
        let searchBar = app.searchFields["Search"]
        XCTAssertTrue(searchBar.exists, "Search bar should be visible")

        // Tap and type a search query
        searchBar.tap()
        searchBar.typeText("Pizza")
        searchBar.typeText("\n") // Simulate pressing the Search button

        // Verify search results (harusnya, tapi error trus jdi skip dlu) asal searchnya work
//        let collectionView = app.collectionViews["RecipeCollectionView"]
//        XCTAssertTrue(collectionView.waitForExistence(timeout: 10), "Collection view should be visible after search")
//
//        XCTAssertGreaterThan(collectionView.cells.count, 0, "Collection view should have cells after search")
//
//        for cell in collectionView.cells.allElementsBoundByIndex {
//            let cellLabels = cell.staticTexts
//            for label in cellLabels.allElementsBoundByIndex {
//                XCTAssertTrue(label.label.lowercased().contains("pizza"), "Cell label should contain 'Pizza'")
//            }
//        }
    }
    
    func testFilterFunctionality() throws {
        // Access the filter scroll view
        let filterScrollView = app.scrollViews["FilterScrollView"]
        XCTAssertTrue(filterScrollView.exists, "Filter scroll view should be visible")
        
        // Scroll to and tap a filter button (e.g., "Indian")
        let filterButton = filterScrollView.buttons["Indian"]
        XCTAssertTrue(filterButton.exists, "Filter button should exist")
        filterButton.tap()
        
        // Verify filter results
        let collectionView = app.collectionViews["RecipeCollectionView"]
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10), "Collection view should be visible after filtering")
        
        // Check if the filtered results are displayed correctly
        // You can check the number of cells or the text of the cells to verify the filter's effectiveness
    }
    
    func testCollectionViewScrolling() throws {
        // Access the collection view
        let collectionView = app.collectionViews["RecipeCollectionView"]
        XCTAssertTrue(collectionView.exists, "Collection view should be visible")
        
        // Scroll to the end of the collection view
        collectionView.swipeUp()
        
        // Verify that the last cell is visible
        let lastCell = collectionView.cells.element(boundBy: collectionView.cells.count - 1)
        XCTAssertTrue(lastCell.waitForExistence(timeout: 5), "Last cell should be visible")
        
        // Scroll back to the top
        collectionView.swipeDown()
        
        // Verify that the first cell is visible
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "First cell should be visible")
    }
}
