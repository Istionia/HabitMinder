//
//  WelcomeViewToolbar.swift
//  HabitMinder
//
//  Created by Timothy on 29/06/2023.
//

import SwiftUI

/// The toolbar for `WelcomeView`.
struct WelcomeViewToolbar: View {
    /// A property to enable this view to access the data controller.
    @EnvironmentObject var dataController: DataController

    var body: some View {
        Menu {
            Button(dataController.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                dataController.filterEnabled.toggle()
            }

            Divider()

            Menu("Sort By") {
                Picker("Sort By", selection: $dataController.sortType) {
                    Text("Date Created").tag(SortType.dateCreated)
                    Text("Date Modified").tag(SortType.dateModified)
                }

                Divider()

                Picker("Sort Order", selection: $dataController.sortNewestFirst) {
                    Text("Newest to Oldest").tag(true)
                    Text("Oldest to Newest").tag(false)
                }
            }

            Picker("Status", selection: $dataController.filterStatus) {
                Text("All").tag(Status.all)
                Text("Unfinished").tag(Status.unfinished)
                Text("Done").tag(Status.done)
            }
            .disabled(dataController.filterEnabled == false)

            Picker("Priority", selection: $dataController.filterPriority) {
                Text("All").tag(-1)
                Text("Low").tag(0)
                Text("Medium").tag(1)
                Text("High").tag(2)
            }
            .disabled(dataController.filterEnabled == false)
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .symbolVariant(dataController.filterEnabled ? .fill : .none)
                .accessibilityLabel("Filter")
                .accessibilityIdentifier("Filter")
        }

        Button(action: dataController.newHabit) {
            Label("New Habit", systemImage: "square.and.pencil")
        }
    }
}

struct WelcomeViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeViewToolbar()
    }
}
