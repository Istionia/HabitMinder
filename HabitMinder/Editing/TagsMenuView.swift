//
//  TagsMenuView.swift
//  HabitMinder
//
//  Created by Timothy on 29/06/2023.
//

import SwiftUI

/// The view that displays the tags menu.
struct TagsMenuView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var habit: Habit

    var body: some View {
        Menu {
            // show selected tags first
            ForEach(habit.habitTags) { tag in
                Button {
                    habit.removeFromTags(tag)
                } label: {
                    Label(tag.tagName, systemImage: "checkmark")
                }
            }

            // now show unselected tags
            let otherTags = dataController.missingTags(from: habit)

            if otherTags.isEmpty == false {
                Divider()

                Section("Add Tags") {
                    ForEach(otherTags) { tag in
                        Button(tag.tagName) {
                            habit.addToTags(tag)
                        }
                    }
                }
            }
        } label: {
            Text(habit.habitTagsList)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(nil, value: habit.habitTagsList)
        }
    }
}

struct TagsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TagsMenuView(habit: .example)
    }
}
