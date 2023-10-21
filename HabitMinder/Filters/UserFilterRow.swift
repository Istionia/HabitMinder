//
//  UserFilterRow.swift
//  HabitMinder
//
//  Created by Timothy on 29/06/2023.
//

import SwiftUI

/// The user filter row type.
struct UserFilterRow: View {
    var filter: Filter
    var rename: (Filter) -> Void
    var delete: (Filter) -> Void

    var body: some View {
        NavigationLink(value: filter) {
            Label(filter.name, systemImage: filter.icon)
        }
        .badge(filter.activeHabitsCount)
        .contextMenu {
            Button {
                rename(filter)
            } label: {
                Label("Rename", systemImage: "pencil")
            }

            Button(role: .destructive) {
                delete(filter)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .accessibilityElement()
        .accessibilityLabel(filter.name)
        .accessibilityHint("\(filter.activeHabitsCount) issues")
    }
}

struct UserFilterRow_Previews: PreviewProvider {
    static var previews: some View {
        UserFilterRow(filter: Filter.example, rename: { print("Renaming \($0)") }, delete: { print("Deleting \($0)") })
    }
}
