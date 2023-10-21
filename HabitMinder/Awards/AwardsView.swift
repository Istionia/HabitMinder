//
//  AwardsView.swift
//  HabitMinder
//
//  Created by Timothy on 27/06/2023.
//

import SwiftUI

struct AwardsView: View {
    /// An environment object that enables access to data controller for AwardsView.
    @EnvironmentObject var dataController: DataController

    /// A state for monitoring the selected award.
    @State private var selectedAward = Award.example
    /// A state that monitors whether award details are shown.
    @State private var showingAwardDetails = false

    /// A property that defines the columns we use - they're adaptive
    /// because we want SwiftUI to handle adjustments for us.
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }

    /// A property that shows whether the user has earned the award in question or not.
    var awardTitle: String {
        if dataController.hasEarned(award: selectedAward) {
            return "Unlocked: \(selectedAward.name)"
        } else {
            return "Locked"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(color(for: award))
                        }
                        .accessibilityLabel(label(for: award))
                        .accessibilityHint(award.description)
                    }
                }
            }
            .navigationTitle("Awards")
        }
        .alert(awardTitle, isPresented: $showingAwardDetails) {

        } message: {
            Text(selectedAward.description)
        }
    }

    /// Calculates the colour for our awards.
    /// - Parameter award: The `Award` that the user is looking up.
    /// - Returns: The `Color` for the award.
    func color(for award: Award) -> Color {
        dataController.hasEarned(award: award) ? Color(award.color): .secondary.opacity(0.5)
    }

    /// Calculates the accessibility label for our awards.
    /// - Parameter award: The `Award` that the user is looking up.
    /// - Returns: The accessibility label for said award.
    func label(for award: Award) -> LocalizedStringKey {
        dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked"
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}
