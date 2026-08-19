//
//  CachableEntity.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import CoreData

// MARK: - Protocol

protocol CachableEntity: NSManagedObject {
    static var entityName: String { get }
    static var uniqueKeyPath: String { get }
}

// MARK: - Generic Operations

extension NSManagedObjectContext {

    func findOrCreate<T: CachableEntity>(uniqueValue: String) -> T {
        if let existing: T = fetchFirst(uniqueValue: uniqueValue) { return existing }
        return NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as! T
    }

    func fetchFirst<T: CachableEntity>(uniqueValue: String) -> T? {
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.predicate = NSPredicate(format: "%K == %@", T.uniqueKeyPath, uniqueValue)
        request.fetchLimit = 1
        return try? fetch(request).first
    }

    func fetchAll<T: CachableEntity>(
        sortDescriptors: [NSSortDescriptor] = [],
        predicate: NSPredicate? = nil
    ) -> [T] {
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        return (try? fetch(request)) ?? []
    }

    func deleteAll<T: CachableEntity>(_ type: T.Type) {
        let entities: [T] = fetchAll()
        entities.forEach { delete($0) }
    }
}
