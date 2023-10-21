//
//  WelcomeView.swift
//  HabitMinder
//
//  Created by Timothy on 24/06/2023.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        List(selection: $viewModel.dataController.selectedHabit) {
            ForEach(viewModel.dataController.habitsForSelectedFilter()) { habit in
                HabitRow(habit: habit)
            }
            .onDelete(perform: viewModel.delete)
        }
        .navigationTitle("Habits")
        // swiftlint:disable line_length
        .searchable(text: $viewModel.filterText, tokens: $viewModel.filterTokens, suggestedTokens: .constant(viewModel.suggestedFilterTokens), prompt: "Filter habits, or type # to add tags") { tag in
            Text(tag.tagName)
        }
        .toolbar(content: WelcomeViewToolbar.init)
    }
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(dataController: .preview)
    }
}
// swiftlint:enable line_length
