//
//  Filter.swift
//  HabitMinder
//
//  Created by Timothy on 26/06/2023.
//

import Foundation

/// A filter that allows the user to select one particular tag,
/// or a built-in smart mailbox that contains a predetermined filter.
///
/// Each filter has a name and an icon for screen display, along with an optional Tag instance
/// in case we're filtering using one of the user's tags.
///
/// The unique identifier is there to conform to the 'Identifiable' protocol, and
/// there's a minimum creation date so we can search specifically for recent habits.
struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var tag: Tag?

    var activeHabitsCount: Int {
        (tag?.tagActiveHabits.count) ?? 0
    }

    /// A constant value that represents the smart mailbox "All".
    static var all = Filter(id: UUID(), name: "All", icon: "tray")
    /// A constant value that represents the smart mailbox "Recently Added".
    static var recent = Filter(id: UUID(),
                               name: "Recently Added",
                               icon: "clock",
                               minModificationDate: .now.addingTimeInterval(86400 * -7))

    /// Compares two filters by using the id property.
    /// - Parameter hasher: provides a randomly seeded, universal hash function.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}

extension Filter {
    /// A handy example Filter for easy use whenever there's a preview.
    static var example: Filter {
        Filter(id: UUID(), name: "Example Filter", icon: "tray")
    }
}
