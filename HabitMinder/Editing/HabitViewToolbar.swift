//
//  HabitViewToolbar.swift
//  HabitMinder
//
//  Created by Timothy on 29/06/2023.
//

import SwiftUI

/// The toolbar for `HabitView.`
struct HabitViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var habit: Habit

    var openCloseButtonText: LocalizedStringKey {
        habit.completed ? "Restore Habit" : "Mark as complete!"
    }

    var body: some View {
        Menu {
            Button {
                UIPasteboard.general.string = habit.title
            } label: {
                Label("Copy Habit Title", systemImage: "doc.on.doc")
            }

            Button {
                habit.completed.toggle()
                dataController.save()
            } label: {
                Label(openCloseButtonText, systemImage: "bubble.left.and.exclamation.mark.bubble.right")
            }

            Divider()

            Section("Tags") {
                TagsMenuView(habit: habit)
            }
        } label: {
            Label("Actions", systemImage: "ellipsis.circle")
        }
    }
}

struct HabitViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        HabitViewToolbar(habit: .example)
    }
}
