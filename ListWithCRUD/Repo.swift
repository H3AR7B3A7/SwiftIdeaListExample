//
//  Repo.swift
//  ListWithCRUD
//
//  Created by mobapp12 on 20/01/2020.
//  Copyright © 2020 H3AR7B3A7. All rights reserved.
//

import Foundation
import CoreData

class Repo{
    // MARK: Singleton pattern
    static let sharedInstance:Repo = Repo.init()
    private init(){
    }
    
    // MARK: CORE DATA
    lazy var persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer.init(name: "Model")
        container.loadPersistentStores(completionHandler: {(storeDescription, error)in
            // Foutafhandeling
        })
        return container
    }()
    private func saveContext(){
        let context =  persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let fout = error as NSError
                print("fout \(fout.localizedDescription)")
            }
        }
    }
    // MARK: CRUD
    // Create
    func saveIdea(title:String, content:String?){
        let newIdea = Idea.init(context: persistentContainer.viewContext)
        newIdea.title = title
        newIdea.content = content
        
        saveContext()
    }
    
    // Read
    func getAllIdeas() -> [Idea]{
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Idea")
        
        do {
            let ideas = try persistentContainer.viewContext.fetch(request) as! [Idea]
            return ideas
        } catch {
            return []
        }
    }
    
    // Read-filtered
    func getIdeasByPartOfTitle(filter:String) -> [Idea] {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Idea")
        let predicate = NSPredicate.init(format: "title CONTAINS[cd] %@", filter)
        request.predicate = predicate
        do {
            return try persistentContainer.viewContext.fetch(request) as! [Idea]
        } catch {
            return []
        }
    }
    
    // Update
    func updateIdea(objectId:NSManagedObjectID, title:String, content: String){
        // Find Idea by ID
        do {
            let idea = try persistentContainer.viewContext.existingObject(with: objectId) as! Idea
            idea.title = title
            idea.content = content
        } catch {
            // Cought
        }
        saveContext()
    }
    
    // Delete
    func deleteIdea(ideaToDelete:Idea){
        persistentContainer.viewContext.delete(ideaToDelete)
        saveContext()
    }
    
}
