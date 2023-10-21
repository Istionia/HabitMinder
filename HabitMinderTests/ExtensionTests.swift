//
//  ExtensionTests.swift
//  HabitMinderTests
//
//  Created by Timothy on 04/07/2023.
//

import XCTest
@testable import HabitMinder
import SwiftUI
import Firebase

class ExtensionTests: BaseTestCase {
    func testHabitTitleUnwrap() {
        // Given
        let habit = Habit(context: managedObjectContext)

        // When
        habit.title = "Example habit"
        // Then
        XCTAssertEqual(habit.habitTitle, "Example habit", "Changing title should also change habitTitle.")

        // When
        habit.title = "Updated habit"
        // Then
        XCTAssertEqual(habit.habitTitle, "Updated habit", "Changing habitTitle should also change title.")
    }

    func testHabitContentUnwrap() {
        let habit = Habit(context: managedObjectContext)

        habit.content = "Example habit"
        XCTAssertEqual(habit.habitContent, "Example habit", "Changing content should also change habitContent.")

        habit.content = "Updated habit"
        XCTAssertEqual(habit.habitContent, "Updated habit", "Changing habitContent should also change content.")
    }

    func testHabitCreationDateUnwrap() {
        let habit = Habit(context: managedObjectContext)
        let testDate = Date.now

        habit.creationDate = testDate
        XCTAssertEqual(habit.habitCreationDate, testDate, "Changing creationDate should also change habitCreationDate.")
    }

    func testHabitTagsUnwrap() {
        let tag = Tag(context: managedObjectContext)
        let habit = Habit(context: managedObjectContext)

        XCTAssertEqual(habit.habitTags.count, 0, "A new habit should have no tags.")
        habit.addToTags(tag)

        XCTAssertEqual(habit.habitTags.count, 1, "Adding 1 tag to a habit should result in habitTags having count 1.")
    }

    func testHabitTagsList() {
        let tag = Tag(context: managedObjectContext)
        let habit = Habit(context: managedObjectContext)

        tag.name = "My Tag"
        habit.addToTags(tag)

        XCTAssertEqual(habit.habitTagsList, "My Tag", "Adding 1 tag to a habit should make habitTagsList be My Tag.")
    }

    func testHabitSortingIsStable() {
        let habit1 = Habit(context: managedObjectContext)
        habit1.title = "Habit B"
        habit1.creationDate = .now

        let habit2 = Habit(context: managedObjectContext)
        habit2.title = "Habit B"
        habit2.creationDate = .now.addingTimeInterval(1)

        let habit3 = Habit(context: managedObjectContext)
        habit3.title = "Habit A"
        habit3.creationDate = .now.addingTimeInterval(100)

        let allHabits = [habit1, habit2, habit3]
        let sorted = allHabits.sorted()

        XCTAssertEqual([habit3, habit1, habit2], sorted, "Sorting habit arrays should use name then creation date.")
    }

    func testTagIDUnwrap() {
        let tag = Tag(context: managedObjectContext)

        tag.id = UUID()
        XCTAssertEqual(tag.tagID, tag.id, "Changing id should also change tagID.")
    }

    func testTagNameUnwrap() {
        let tag = Tag(context: managedObjectContext)
        tag.name = "Example tag"

        XCTAssertEqual(tag.name, "Example tag", "Changing name should also change tagName.")

        tag.name = "Updated tag"
        XCTAssertEqual(tag.name, "Updated tag", "Changing tagName should also change name.")
    }

    func testTagActiveHabits() {
        let tag = Tag(context: managedObjectContext)
        let habit = Habit(context: managedObjectContext)

        XCTAssertEqual(tag.tagActiveHabits.count, 0, "By default, there shouldn't be any active habits to start with.")

        tag.addToHabits(habit)
        XCTAssertEqual(tag.tagActiveHabits.count, 1, "When a habit is added there should be 1 active habit.")

        habit.completed = true
        XCTAssertEqual(tag.tagActiveHabits.count, 0,
                       "When a habit is marked as complete, the habit should no longer be marked as active.")
    }

    func testTagSortingIsStable() {
        let tag1 = Tag(context: managedObjectContext)
        tag1.name = "Tag B"
        tag1.id = UUID()

        let tag2 = Tag(context: managedObjectContext)
        tag2.name = "Tag B"
        tag2.id = UUID(uuidString: "FFFFFFFF-517E-4001-9C8D-F1A5F2409534")

        let tag3 = Tag(context: managedObjectContext)
        tag3.name = "Tag A"
        tag3.id = UUID()

        let allTags = [tag1, tag2, tag3]
        let sortedTags = allTags.sorted()

        XCTAssertEqual([tag3, tag1, tag2], sortedTags, "Sorting tag arrays should use name then UUID strings.")
    }

    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode("Awards.json", as: [Award].self)
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array.")
    }

    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableString.json", as: String.self)
        XCTAssertEqual(data, "Ay mariposas, don't you hold on too tight", "The string must match DecodableString.json.")
    }

    func testDecodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableDictionary.json", as: [String: Int].self)
        XCTAssertEqual(data.count, 3, "There should be three items decoded from DecodableDictionary.json.")
        XCTAssertEqual(data["Two"], 2, "When one specific item is requested, that specific item must be returned.")
    }
}
