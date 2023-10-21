//
//  HabitRow.swift
//  HabitMinder
//
//  Created by Timothy on 26/06/2023.
//

import SwiftUI

struct HabitRow: View {
    /// An @ObservedObject property that passes in the Core Data Habit attribute.
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationLink(value: viewModel.habit) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(viewModel.iconOpacity)
                    .accessibilityIdentifier(viewModel.iconIdentifier)

                VStack(alignment: .leading) {
                    Text(viewModel.habitTitle)
                        .font(.headline)
                        .lineLimit(2...2)
                        .accessibilityIdentifier("arbitrary")

                    Text(viewModel.habitTagsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(2...2)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(viewModel.creationDate)
                        .accessibilityLabel(viewModel.accessibilityCreationDate)
                        .font(.subheadline)

                    if viewModel.completed {
                        Text("COMPLETED")
                            .font(.body.uppercaseSmallCaps())
                    }
                }
            }
        }
        .accessibilityHint(viewModel.accessibilityHint)
        .accessibilityIdentifier(viewModel.habitTitle)
    }
    
    init(habit: Habit) {
        let viewModel = ViewModel(habit: habit)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct HabitRow_Previews: PreviewProvider {
    static var previews: some View {
        HabitRow(habit: .example)
    }
}
