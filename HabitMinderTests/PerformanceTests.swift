//
//  PerformanceTests.swift
//  HabitMinderTests
//
//  Created by Timothy on 08/07/2023.
//

import XCTest
@testable import HabitMinder
import Firebase

class PerformanceTests: BaseTestCase {
    func testAwardCalculationPerformance() {
        // Create a significant amount of test data
        for _ in 1...100 {
            dataController.createSampleData()
        }

        // Simulate a shit-ton of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the award count is constant. Change this if you add awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}
