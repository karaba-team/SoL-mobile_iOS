//
//  coreDataManager.swift
//  Karaba
//
//  Created by Rem Remy on 14/11/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    static let sharedManager = CoreDataManager()
    private init(){}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ObjectDataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Can't Save Data")
            }
        }
    }
}
