//
//  DetailView.swift
//  HabitMinder
//
//  Created by Timothy on 25/06/2023.
//

import SwiftUI

/// The view where `HabitView` and `NoHabitView` are accessed.
struct DetailView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        VStack {
            if let habit = dataController.selectedHabit {
                HabitView(habit: habit)
            } else {
                NoHabitView()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
