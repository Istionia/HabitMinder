//
//  SidebarViewModel.swift
//  HabitMinder
//
//  Created by Timothy Yoong Jie Gen on 21/10/2023.
//

import CoreData
import Foundation

extension SidebarView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let tagsController: NSFetchedResultsController<Tag>
        @Published var tags = [Tag]()

        /// Property that tracks which tag users are trying to rename.
        var tagToRename: Tag?
        /// Property that tracks whether renaming is currently in progress or not
        var renamingTag = false
        /// Property that tracks what the new tag name ought to be.
        var tagName = ""

        /// A computed property that converts all our tags into matching filters,
        /// adding in the correct icon.
        var tagFilters: [Filter] {
            tags.map { tag in
                Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
            }
        }
        
        /// Stores access to the data controller.
        var dataController: DataController
        
        init(dataController: DataController) {
            self.dataController = dataController
            
            let request = Tag.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Tag.name, ascending: true)]
            
            tagsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataController.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            super.init()
            tagsController.delegate = self
            
            do {
                try tagsController.performFetch()
                self.tags = tagsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch tags")
            }
        }
        
        /// Adds swipe to delete support.
        /// - Parameter offsets: specified offsets that correspond to 'IndexSet'.
        func delete(_ offsets: IndexSet) {
            for offset in offsets {
                let item = tags[offset]
                dataController.delete(item)
            }
        }

        /// Deletes filters.
        /// - Parameter filter: Filter that the user intends to delete.
        func delete(_ filter: Filter) {
            guard let tag = filter.tag else {
                return
            }

            dataController.delete(tag)
            dataController.save()
        }

        /// Start the renaming process.
        /// - Parameter filter: Accepts a Filter.
        func rename(_ filter: Filter) {
            tagToRename = filter.tag
            tagName = filter.name
            renamingTag = true
        }

        /// Updates the renamed tag and triggers a save.
        func completeRename() {
            tagToRename?.name = tagName
            dataController.save()
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newTags = controller.fetchedObjects as? [Tag] {
                tags = newTags
            }
        }
    }
}
