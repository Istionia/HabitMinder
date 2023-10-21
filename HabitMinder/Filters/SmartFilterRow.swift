//
//  SmartFilterRow.swift
//  HabitMinder
//
//  Created by Timothy on 29/06/2023.
//

import SwiftUI

/// The smart filter row type.
struct SmartFilterRow: View {
    var filter: Filter

    var body: some View {
        NavigationLink(value: filter) {
            Label(LocalizedStringKey(filter.name), systemImage: filter.icon)
        }
    }
}

struct SmartFilterRow_Previews: PreviewProvider {
    static var previews: some View {
        SmartFilterRow(filter: Filter(id: UUID(), name: "", icon: ""))
    }
}
