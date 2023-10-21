//
//  Award.swift
//  HabitMinder
//
//  Created by Timothy on 27/06/2023.
//

import Foundation

struct Award: Decodable, Identifiable {
    /// A property that enables conformance to `Identifiable`.
    var id: String { name }
    var name: String
    var description: String
    var color: String
    var criterion: String
    var value: Int
    var image: String

    /// A static property that loads `Awards.json` using the extension `Bundle-Decodable`.
    static let allAwards = Bundle.main.decode("Awards.json", as: [Award].self)
    /// A static property that loads the first award in `Awards.json`.
    static let example = allAwards[0]
}
