//
//  HabitView.swift
//  HabitMinder
//
//  Created by Timothy on 26/06/2023.
//

import SwiftUI

/// The view where users input their habits.
struct HabitView: View {
    /// A property that allows HabitView to access the data controller.
    @EnvironmentObject var dataController: DataController
    /// A non-optional Habit view for HabitView to read from.
    @ObservedObject var habit: Habit

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    LabeledContent("Name") {
                        VStack(alignment: .leading) {
                            TextField("Title", text: $habit.habitTitle, prompt: Text("New habit"))
                                .font(.title2)
                                .accessibilityLabel("Title")
                                .accessibilityIdentifier("Title")

                            Divider()

                            Text("**Modified**\(habit.habitModificationDate.formatted(date: .long, time: .shortened))")
                                .foregroundStyle(.secondary)

                            Divider()

                            Text("**Status:**\(habit.habitStatus)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Picker("Priority", selection: $habit.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }

                TagsMenuView(habit: habit)
            }

            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }

                TextField("Description",
                          text: $habit.habitContent,
                          prompt: Text("What do you want to do?"),
                          axis: .vertical
                )
                .accessibilityIdentifier("Description")
                .accessibilityLabel("Description")
            }
        }
        .disabled(habit.isDeleted)
        .onReceive(habit.objectWillChange) { _ in
            dataController.queueSave()
        }
        .onSubmit(dataController.save)
        .toolbar {
            HabitViewToolbar(habit: habit)
        }
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView(habit: .example)
    }
}
