//
//  WelcomeViewModel.swift
//  HabitMinder
//
//  Created by Timothy Yoong Jie Gen on 22/10/2023.
//

import Foundation

extension WelcomeView {
    @dynamicMemberLookup
    class ViewModel: ObservableObject {
        subscript<Value>(dynamicMember keyPath: KeyPath<DataController, Value>) -> Value {
            dataController[keyPath: keyPath]
        }
        
        subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<DataController, Value>) -> Value {
            get { dataController[keyPath: keyPath] }
            set { dataController[keyPath: keyPath] = newValue }
        }
        
        var dataController: DataController
        
        init(dataController: DataController) {
            self.dataController = dataController
        }
        
        /// Adds swipe to delete support.
        /// - Parameter offsets: specified offsets that correspond to 'IndexSet'.
        func delete(_ offsets: IndexSet) {
            let habits = dataController.habitsForSelectedFilter()

            for offset in offsets {
                let item = habits[offset]
                dataController.delete(item)
            }
        }
    }
}
