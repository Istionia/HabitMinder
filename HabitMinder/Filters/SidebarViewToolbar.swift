//
//  SidebarViewToolbar.swift
//  HabitMinder
//
//  Created by Timothy on 29/06/2023.
//

import SwiftUI

/// The toolbar for `SidebarView`.
struct SidebarViewToolbar: View {
    /// An environment object that enables access to the data controller.
    @EnvironmentObject var dataController: DataController
    /// A piece of state that tracks whether the awards sheet is showing or not.
    @State var showingAwards: Bool = false

    var body: some View {
        #if DEBUG
        Button {
            dataController.deleteAll()
            dataController.createSampleData()
        } label: {
            Label("ADD SAMPLES", systemImage: "flame")
        }
        #endif

        Button(action: dataController.newTag) {
            Label("Add tag", systemImage: "plus")
        }

        Button {
            showingAwards.toggle()
        } label: {
            Label("Show awards", systemImage: "rosette")
        }
        .sheet(isPresented: $showingAwards, content: AwardsView.init)
    }
}

struct SidebarViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarViewToolbar(showingAwards: true)
            .environmentObject(DataController.preview)
    }
}
