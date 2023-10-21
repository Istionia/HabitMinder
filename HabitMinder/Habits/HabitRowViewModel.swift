//
//  HabitRowViewModel.swift
//  HabitMinder
//
//  Created by Timothy Yoong Jie Gen on 22/10/2023.
//

import Foundation

extension HabitRow {
    @dynamicMemberLookup
    class ViewModel: ObservableObject {
        subscript<Value>(dynamicMember keyPath: KeyPath<Habit, Value>) -> Value {
            habit[keyPath: keyPath]
        }
        
        let habit: Habit
        
        var iconOpacity: Double {
            habit.priority == 2 ? 1 : 0
        }
        
        var iconIdentifier: String {
            habit.priority == 2 ? "\(habit.habitTitle) High priority" : ""
        }
        
        var accessibilityHint: String {
            habit.priority == 2 ? "High priority" : ""
        }
        
        var creationDate: String {
            habit.habitCreationDate.formatted(date: .numeric, time: .omitted)
        }
        
        var accessibilityCreationDate: String {
            habit.habitCreationDate.formatted(date: .abbreviated, time: .omitted)
        }
        
        init(habit: Habit) {
            self.habit = habit
        }
    }
}
