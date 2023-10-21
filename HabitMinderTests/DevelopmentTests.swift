//
//  DevelopmentTests.swift
//  HabitMinderTests
//
//  Created by Timothy on 04/07/2023.
//

import XCTest
import Foundation
@testable import HabitMinder
import Firebase

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() {
        // When
        try dataController.createSampleData()

        // Then
        XCTAssertEqual(dataController.count(for: Habit.fetchRequest()), 50, "There should be 50 sample habits.")
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 5, "There should be 5 sample tags.")
    }

    func testDeleteAllRemovesEverything() {
        // When
        try dataController.createSampleData()
        dataController.deleteAll()

        // Then
        XCTAssertEqual(dataController.count(for: Habit.fetchRequest()), 0, "deleteAll() should leave no habits.")
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 0, "deleteAll() should leave no tags.")
    }

    func testExampleHabitIsHighPriority() {
        // When
        let habit = Habit.example

        // Then
        XCTAssertEqual(habit.priority, 4, "The example habit should be high priority.")
    }
}
