//
//  HabitMinderScreenshotTests.swift
//  HabitMinderUITests
//
//  Created by Timothy on 20/07/2023.
//

import XCTest

final class HabitMinderScreenshotTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
}
