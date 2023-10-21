//
//  HabitMinderUITests.swift
//  HabitMinderUITests
//
//  Created by Timothy on 18/08/2023.
//

import XCTest

extension XCUIElement {
    /// Clear the text from a user element, such as a text field.
    func clear() {
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear text in XCUIElement.")
            return
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}

final class HabitMinderUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test.
        app = XCUIApplication()
        // enable-testing clears any saved habits or tags.
        app.launchArguments = ["enable-testing"]
        // enable Fastlane snapshots
        setupSnapshot(app, waitForAnimations: false)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation -
        // required for your tests before they run. The setUp method is a good place to do this.
    }

    func testAppStartsWithNavigationBar() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
                XCTAssertTrue(app.navigationBars.element.exists,
                              "There should be a navigation bar when the app launches.")
    }

    func testAppHasBasicButtonsOnLaunch() {
        XCTAssertTrue(app.navigationBars.buttons["Filters"].exists, "There should be a Filters button launch.")
        XCTAssertTrue(app.navigationBars.buttons["Filter"].exists, "There should be a Filter button launch.")
        XCTAssertTrue(app.navigationBars.buttons["New Habit"].exists, "There should be a New Habit button launch.")
    }

    func testNoHabitsAtStart() {
        // setUpWithError clears any habits so this should be zero.
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")
        snapshot("01InitialScreen")
    }

    func testCreatingAndDeletingHabits() {
        for tapCount in 1...5 {
            app.buttons["New Habit"].tap()
            print(app.debugDescription)
            sleep(1)
            assertHabitCount(is: tapCount)
        }

        snapshot("02HabitCreation")

        for tapCount in (0...4).reversed() {
            app.cells.firstMatch.swipeLeft()
            print(app.debugDescription)
            app.buttons["Delete"].tap()
            snapshot("03HabitDeletion")
            print(app.debugDescription)
            sleep(1)
            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }
    }

    func testEditingHabitTitleUpdatesCorrectly() {
        let sampleText = "Greet people sentimentally every time you see them."
        XCTAssertEqual(app.cells.count, 0, "There shouldn't be any list rows initially.")

        inputTestHabit(text: sampleText)
        snapshot("04EditingHabits")
        // switch back to Habits list
        switchToHabitsTab()
        // find the title that should match our new habit's name!
        let habitTitleView = getTextView(matching: sampleText)
        XCTAssertTrue(habitTitleView.exists)
    }

    func testEditingHabitPriorityShowsIcon() {
        app.buttons["New Habit"].tap()
        print(app.debugDescription)
        sleep(1)
        app.buttons["Priority, Medium"].tap()
        print(app.debugDescription)
        sleep(1)
        app.buttons["High"].tap()
        print(app.debugDescription)
        sleep(1)
        switchToHabitsTab()

        let identifier = "New habit High priority"
        XCTAssertTrue(app.images[identifier].exists, "A high priority habit needs an icon next to it.")

        snapshot("05HabitEditingIcon")
    }

    func testAllAwardsShowLockedAlert() {
        app.navigationBars.buttons["Filters"].tap()
        app.buttons["Show awards"].tap()
        app.swipeDown()
        snapshot("06LockedAwards")
        print(app.debugDescription)
        sleep(1)
        tapAwardButton()
    }

    func testRunSearch() {
        let sampleText = "Greet people sentimentally every time you see them."
        inputTestHabit(text: sampleText)

        sleep(1)
        app.buttons["Habits"].tap()
        sleep(1)
        print(app.debugDescription)
        let filterField = app.searchFields["Filter habits, or type # to add tags"]
        snapshot("07FilterHabits")
        sleep(1)
        filterField.tap()
        sleep(1)
        filterField.typeText(sampleText)
        snapshot("08TypeToSearchHabits")
        sleep(1)
        let habitTitleView = getTextView(matching: sampleText)
        XCTAssertTrue(habitTitleView.exists)
    }

    // MARK: - Test Helpers

    /// Find a text view that matches the given string
    /// - Parameter text: The String of texts to search for
    /// - Returns: An `XCUIElement` for the TextView.
    private func getTextView(matching text: String) -> XCUIElement {
        let predicate = NSPredicate(format: "label CONTAINS[c] '\(text)'")
        let staticTexts = app.staticTexts
        return staticTexts.element(matching: predicate)
    }

    /// Create a new habit for testing purposes
    /// - Parameter text: The String of text to input
    private func inputTestHabit(text: String) {
        // Go to the New Habit form
        app.buttons["New Habit"].tap()
        // Find the Name field
        let titleField = app.textFields.matching(identifier: "Title").firstMatch
        titleField.tap()
        // Empty the name field
        titleField.clear()
        // put our text in the name field
        app.typeText(text)
    }

    /// Tap the Habits tab button.
    fileprivate func switchToHabitsTab() {
        app.buttons["Habits"].tap()
    }

    /// Tap the Awards button.
    fileprivate func tapAwardButton() {
        for awardButton in app.scrollViews.buttons.allElementsBoundByIndex {
            awardButton.tap()
            XCTAssertTrue(app.alerts["Locked"].exists,
                          "Any attempts to access the awards without earning them should reveal a Locked alert.")
            if app.windows.element.frame.contains(awardButton.frame) == false {
                // get rid of the alert!
                app.swipeUp()
            }

            app.buttons["OK"].tap()
        }
    }

    /// Assert that there are a given number of Habits in the app.
    ///
    /// Tries to switch to the Habits screen first!
    /// - Parameters:
    ///   - number: The number of Habits expected.
    ///   - message: optional: Message to show when error encountered.
    ///   - file: the source file path
    ///   - line: the source file path number
    private func assertHabitCount(is number: Int, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
        switchToHabitsTab()

        let messageText = message().isEmpty ? "There should be \(number) rows in the list." : message()
        XCTAssertEqual(app.cells.count, number, messageText, file: file, line: line)
    }
}
