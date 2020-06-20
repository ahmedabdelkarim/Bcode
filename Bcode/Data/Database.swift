//
//  Database.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 6/20/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import CoreData

class Database {
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static let context = Database.persistentContainer.viewContext
    
    static func saveContext() -> Bool {
        if(context.hasChanges) {
            do {
                try context.save()
                return true
            } catch {
                return false
            }
        }
        else {
            return true
        }
    }
}
