//
//  Tag-CoreDataHelpers.swift
//  HabitMinder
//
//  Created by Timothy on 26/06/2023.
//

import Foundation

extension Tag {
    var tagID: UUID {
        id ?? UUID()
    }

    var tagName: String {
        name ?? ""
    }

    /// A variable property that shows only active habits - those that haven't been marked as completed.
    var tagActiveHabits: [Habit] {
        let result = habits?.allObjects as? [Habit] ?? []
        return result.filter { $0.completed == false }
    }

    /// A static property that creates an example item for SwiftUI previewing purposes.
    static var example: Tag {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let tag = Tag(context: viewContext)
        tag.id = UUID()
        tag.name = "Example Tag"
        return tag
    }
}

extension Tag: Comparable {
    public static func < (lhs: Tag, rhs: Tag) -> Bool {
        let left = lhs.tagName.localizedLowercase
        let right = rhs.tagName.localizedLowercase

        if left == right {
            return lhs.tagID.uuidString < rhs.tagID.uuidString
        } else {
            return left < right
        }
    }
}
