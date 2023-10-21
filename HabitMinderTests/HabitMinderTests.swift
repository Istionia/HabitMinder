//
//  HabitMinderTests.swift
//  HabitMinderTests
//
//  Created by Timothy on 01/07/2023.
//

import CoreData
import XCTest
import Firebase
@testable import HabitMinder

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
