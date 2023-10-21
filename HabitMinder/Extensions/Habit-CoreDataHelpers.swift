//
//  Habit-CoreDataHelpers.swift
//  HabitMinder
//
//  Created by Timothy on 26/06/2023.
//

import Foundation

/// In all cases, we now have setters AND getters for specific properties, which allows us to modify them directly.
/// (At least all optionals get resolved here rather than muddying the rest of the project, right?)
extension Habit {
    /// A helper property that allows for modification of the habit's title.
    var habitTitle: String {
        get { title ?? ""}
        set { title = newValue }
    }

    /// A helper property that allows for modification of the habit's content.
    var habitContent: String {
        get { content ?? ""}
        set { content = newValue }
    }

    /// A helper property that allows for modification of the habit's creation date.
    var habitCreationDate: Date {
        creationDate ?? .now
    }

    /// A helper property that allows for modification of the habit's modification date.
    var habitModificationDate: Date {
        modificationDate ?? .now
    }

    /// A property that gets tags neatly sorted.
    ///
    /// Wraps up the complicated parts in one place: optional chaining, conversion to [Any],
    /// conditional conversion to [Tag], then nil coalescing to an empty array if any part of that failed.
    var habitTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }

    /// A static property that creates an example item for SwiftUI previewing purposes.
    static var example: Habit {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let habit = Habit(context: viewContext)
        habit.title = "Example Habit"
        habit.content = "This is an example habit."
        habit.priority = 4
        habit.creationDate = .now
        return habit
    }

    /// A helper property to stringify the Boolean correctly.
    var habitStatus: String {
        if completed {
            return "Done"
        } else {
            return "In progress"
        }
    }

    var habitTagsList: String {
        guard let tags else { return "No tags"}

        if tags.count == 0 {
            return "No tags"
        } else {
            return habitTags.map(\.tagName).formatted()
        }
    }
}

extension Habit: Comparable {
    public static func < (lhs: Habit, rhs: Habit) -> Bool {
        let left = lhs.habitTitle.localizedLowercase
        let right = rhs.habitTitle.localizedLowercase

        if left == right {
            return lhs.habitCreationDate < rhs.habitCreationDate
        } else {
            return left < right
        }
    }
}
