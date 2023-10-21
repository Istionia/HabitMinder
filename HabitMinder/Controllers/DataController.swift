//
//  DataController.swift
//  HabitMinder
//
//  Created by Timothy on 24/06/2023.
//

import CoreData
import UIKit
import SwiftUI

/// An enum for selecting how to sort user data - whether by creation date or modification date.
enum SortType: String {
    case dateCreated = "creationDate"
    case dateModified = "modificationDate"
}

/// An enum for filtering by habit status: open, status or closed.
enum Status {
    case all, unfinished, done
}

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, as well as dealing with sample data.
class DataController: ObservableObject {
    @Published var selectedFilter: Filter? = Filter.all
    /// A property that tracks selected habits.
    @Published var selectedHabit: Habit?
    /// A property to store whatever the user has currently typed.
    @Published var filterText = ""
    @Published var filterTokens = [Tag]()

    /// A property to track whether the filetring system is enabled or disabled.
    @Published var filterEnabled = false
    /// A property to track what habit priority the user wants to show first.
    @Published var filterPriority = -1
    /// A property to track habit status
    @Published var filterStatus = Status.all
    /// A property for selecting how to sort user data.
    @Published var sortType = SortType.dateCreated
    /// A property to trcak whether the user wants to sort oldest or newest data first.
    @Published var sortNewestFirst = true

    /// A property to store a Task instance to handle our saving.
    private var saveTask: Task<Void, Error>?

    static var modeL: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to locate model file.")
        }

        return managedObjectModel
    }()

    var suggestedFilterTokens: [Tag] {
        guard filterText.starts(with: "#") else {
            return []
        }

        let trimmedFilterText = String(filterText.dropFirst()).trimmingCharacters(in: .whitespaces)
        let request = Tag.fetchRequest()

        if trimmedFilterText.isEmpty == false {
            request.predicate = NSPredicate(format: "name contains [C] %@", trimmedFilterText)
        }

        return (try? container.viewContext.fetch(request).sorted()) ?? []
    }

    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer

    /// Initializes a data controller, either in memory (for temporary use such as browsing and previewing),
    /// or as permanent storage (for use in regular app runs.)
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    @available(macOS 13.0, *)
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.modeL)

        // For testing and previewing purposes, we create a
        // temporary, in-memory database by writing to /dev/null
        // so our data is destroyed after the app finished running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        // Ensure we watch iCloud for all changes to make
        // absolutely sure we keep our local UI in sync when a
        // remote change happens.
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber,
                                                               forKey:
                                                                NSPersistentStoreRemoteChangeNotificationPostOptionKey
        )
        NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange,
                                               object: container.persistentStoreCoordinator,
                                               queue: .main,
                                               using: remoteStoreChanged
        )

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
                UIView.setAnimationsEnabled(false)
            }
            #endif
        }
    }
    /// Runs a fetch request with various predicates that filter the user's habits based
    /// on tag, title and content text, search tokens, priority, and completion status.
    /// - Returns: An array of all matching habits.
    func habitsForSelectedFilter() -> [Habit] {
        let filter = selectedFilter ?? .all
        var predicates = [NSPredicate]()

        if let tag = filter.tag {
            let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
            predicates.append(tagPredicate)
        } else {
            let datePredicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            predicates.append(datePredicate)
        }

        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)

        if trimmedFilterText.isEmpty == false {
            let titlePredicate = NSPredicate(format: "title CONTAINS [c] %@", trimmedFilterText)
            let contentPredicate = NSPredicate(format: "content CONTAINS [c] %@", trimmedFilterText)
            let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates:
                                                            [titlePredicate, contentPredicate]
            )
            predicates.append(combinedPredicate)
        }

        if filterEnabled {
            if filterPriority >= 0 {
                let priorityFilter = NSPredicate(format: "priority = %d", filterPriority)
                predicates.append(priorityFilter)
            }

            if filterStatus != .all {
                let lookForDone = filterStatus == .done
                let statusFilter = NSPredicate(format: "completed = %@", NSNumber(value: lookForDone))
                predicates.append(statusFilter)
            }
        }

        let request = Habit.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)]

        if filterTokens.isEmpty == false {
            for filterToken in filterTokens {
                let tokenPredicate = NSPredicate(format: "tags CONTAINS %@", filterToken)
                predicates.append(tokenPredicate)
            }
        }

        let allHabits = (try? container.viewContext.fetch(request)) ?? []
        return allHabits
    }

    /// Creates a handy piece of sample data for easy use in previews & simulators.
    func createSampleData() {
        let viewContext = container.viewContext

        for tagCounter in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(tagCounter)"; for habitCounter in 1...10 {
                let habit = Habit(context: viewContext)
                habit.title = "Habit \(tagCounter)-\(habitCounter)"
                habit.content = "Description goes here"
                habit.creationDate = .now
                habit.completed = Bool.random()
                habit.priority = Int16.random(in: 0...2)
                tag.addToHabits(habit)
            }
        }

        try? viewContext.save()
    }

    /// A pre-made data controller suitable for previewing SwiftUI views.
    @available(macOS 13.0, *)
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()

    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all our attributes are optional.
    func save() {
        saveTask?.cancel()

        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    /// Deletes a specific habit or tag from our view context. This is only possible
    /// because all Core Data classes (including the Habit and Tag classes generated by Xcode)
    /// inherit from NSManagedObject.
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }

    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        // MARK: When performing a batch delete we need to make sure we read the result back
        // MARK: then merge all the changes from that result back into our live view context
        // MARK: so the two stay in sync.
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }

    /// Delete all the habits and tags we have stored.
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)

        let request2: NSFetchRequest<NSFetchRequestResult> = Habit.fetchRequest()
        delete(request2)

        save()
    }

    /// Notifies us whenever any writes to our persistent store happen, so we can upadte our UI.
    ///
    /// This allows us to detect changes occurring OUTSIDE of our code and update our UI.
    /// - Parameter notification: A notification that can come from anywhere - even iCloud.
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }

    /// Performs a symmetric difference of our habit's tags and all tags -
    /// tells us all habits that aren't already assigned to the specific tag,
    /// - Parameter habit: A habit provided by the user.
    /// - Returns: An array of all the tags the habit is missing.
    func missingTags(from habit: Habit) -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []

        let allTagSet = Set(allTags)
        let difference = allTagSet.symmetricDifference(habit.habitTags)

        return difference.sorted()
    }

    /// Saves our changes after a delay.
    ///
    /// @MainActor is present to tell the task it needs to run its body on the main actor - why?
    ///
    /// Although Core Data is meant for working well in multi-threaded environments,
    /// it's something that needs to be handled delicately - passing one managed object
    /// between threads can lead to disastrous consequences, which Task makes easy to do by accident.
    ///
    /// So unless especially necessary, best to keep all Core Data work on the main actor.
    func queueSave() {
        saveTask?.cancel()

        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(3))
            save()
        }
    }

    /// Creates a new habit.
    func newHabit() {
        let habit = Habit(context: container.viewContext)
        habit.title = NSLocalizedString("New habit", comment: "Create a new habit")
        habit.creationDate = .now
        habit.priority = 1

        // If we're currently browsing a user-created habit, immediately
        // add this new habit to the tag otherwise it won't appear in
        // the list of habits they see.
        if let tag = selectedFilter?.tag {
            habit.addToTags(tag)
        }

        save()

        selectedHabit = habit
    }

    /// Creates a new tag.
    func newTag() {
        let tag = Tag(context: container.viewContext)
        tag.id = UUID()
        tag.name = NSLocalizedString("New tag", comment: "Create a new tag")
        save()
    }

    /// Removes optionality from reading fetch request counts.
    /// - Parameter fetchRequest: Obtains a fetch request using `NSFetchRequest`.
    /// - Returns: Fetch request count in `Int`.
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    /// Evaluates whether any award has been earned by the user.
    /// - Parameter award: Any award that the user looks up.
    /// - Returns: Whether the user has earned that award or not.
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "habits":
            // returns true if they added a certain number of habits
            let fetchRequest = Habit.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "closed":
            // returns true if they completed a certain number of habits
            let fetchRequest = Habit.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "tags":
            // returns true if they created a certain number of tags
            let fetchRequest = Tag.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
            // unknown award criterion - this should never be allowed
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
}
