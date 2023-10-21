//
//  AssetTests.swift
//  HabitMinderTests
//
//  Created by Timothy on 01/07/2023.
//

import XCTest
@testable import HabitMinder

class AssetTests: BaseTestCase {
    func testColorsExist() {
        // Given
        let allColors = ["Dark Blue", "Dark Gray", "Gold", "Gray", "Green",
        "Light Blue", "Midnight", "Orange", "Pink", "Purple", "Red", "Teal"]

        // When
        for color in allColors {
            // Then
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog")
        }
    }

    func testAwardsLoadCorrectly() {
        XCTAssertTrue(Award.allAwards.isEmpty == false, "Failed to load awards from JSON.")
    }
}
