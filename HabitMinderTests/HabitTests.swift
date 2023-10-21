//
//  HabitTests.swift
//  HabitMinderTests
//
//  Created by Timothy on 01/07/2023.
//

import XCTest
import CoreData
@testable import HabitMinder
import Firebase

class HabitTests: BaseTestCase {
    let awards = Award.allAwards

    func testCreatingHabitsAndItems() {
        // Given
        let targetCount = 10

        // When
        for _ in 0..<targetCount {
            let habit = Habit(context: managedObjectContext)

            for _ in 0..<targetCount {
                let tag = Tag(context: managedObjectContext)
            }
        }

        // Then
        XCTAssertEqual(dataController.count(for: Habit.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingHabitCascadesDeletesItems() throws {
        try dataController.createSampleData()

        // Given
        let request = NSFetchRequest<Habit>(entityName: "Habit")
        let habits = try managedObjectContext.fetch(request)

        // When
        dataController.delete(habits[0])

        // Then
        XCTAssertEqual(dataController.count(for: Habit.fetchRequest()), 49)
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 5)
    }

    func testAwardIDMatchesName() {
        // When
        for award in awards {
            // Then
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
        }
    }

    func noAwards() {
        // When
        for award in awards {
            // Then
            XCTAssertFalse(dataController.hasEarned(award: award),
                           "New users should have earned no awards at the start.")
        }
    }
}
