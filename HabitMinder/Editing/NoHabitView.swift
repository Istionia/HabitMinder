//
//  NoHabitView.swift
//  HabitMinder
//
//  Created by Timothy on 26/06/2023.
//

import SwiftUI

/// The view you first get - where there are no habits at all.
struct NoHabitView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        Text("No Habit Selected")
            .font(.title)
            .foregroundStyle(.secondary)

        Button("New Habit") {
            // create a new habit
            dataController.newHabit()
        }
    }
}

struct NoHabitView_Previews: PreviewProvider {
    static var previews: some View {
        NoHabitView()
    }
}
