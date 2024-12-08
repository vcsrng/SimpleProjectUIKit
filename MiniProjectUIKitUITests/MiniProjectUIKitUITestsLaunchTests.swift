//
//  MiniProjectUIKitUITestsLaunchTests.swift
//  MiniProjectUIKitUITests
//
//  Created by Vincent Saranang on 02/12/24.
//

import XCTest

final class MiniProjectUIKitUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps to perform after launch
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
