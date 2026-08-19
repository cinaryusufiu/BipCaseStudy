//
//  CoreDataStack.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import CoreData

// MARK: - Protocol

protocol CoreDataStackProtocol {
    var viewContext: NSManagedObjectContext { get }
    func saveContext()
    func newBackgroundContext() -> NSManagedObjectContext
}

// MARK: - Implementation

final class CoreDataStack: CoreDataStackProtocol {

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "BipCaseStudy")

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [description]
        }

        configureMergePolicy()
        loadStores()
    }
}

// MARK: - Context

extension CoreDataStack {

    func saveContext() {
        guard viewContext.hasChanges else { return }
        try? viewContext.save()
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}

// MARK: - Private

extension CoreDataStack {

    private func configureMergePolicy() {
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    private func loadStores() {
        persistentContainer.loadPersistentStores { _, error in
            guard let error else { return }
            #if DEBUG
            fatalError("CoreData load error: \(error)")
            #endif
        }
    }
}
