//
//  SidebarView.swift
//  HabitMinder
//
//  Created by Timothy on 25/06/2023.
//

import SwiftUI

/// The view that displays our sidebar.
struct SidebarView: View {
    /// A constant property for storing smart mailboxes.
    let smartFilters: [Filter] = [.all, .recent]
    @StateObject private var viewModel: ViewModel
    
    init(dataController: DataController) {
        let viewModel = ViewModel( dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List(selection: $viewModel.dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters, content: SmartFilterRow.init)
            }

            Section("Tags") {
                ForEach(viewModel.tagFilters) { filter in
                    UserFilterRow(filter: filter, rename: viewModel.rename, delete: viewModel.delete)
                }
                .onDelete(perform: viewModel.delete)
            }
        }
        .toolbar(content: SidebarViewToolbar.init)
        .alert("Rename tag", isPresented: $viewModel.renamingTag) {
            Button("OK", action: viewModel.completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $viewModel.tagName)
        }
        .navigationTitle("Filters")
        .accessibilityLabel("Filters")
        .accessibilityIdentifier("Filters")
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(dataController: .preview)
    }
}
