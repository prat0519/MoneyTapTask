//
//  CoreDataModel.swift
//  MoneyTapTask
//
//  Created by Prashant Pandey on 23/07/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import Foundation
import CoreData


class SearchResultDB {
    
    fileprivate var managedObjectContext: NSManagedObjectContext!
    fileprivate var readManagedObjectContext: NSManagedObjectContext!
    fileprivate var managedObjectModel: NSManagedObjectModel!
    fileprivate var persistnaceStoreCoodinator: NSPersistentStoreCoordinator!
    
    private static var sharedInstance: SearchResultDB = {
        let searchDataInstance = SearchResultDB()
        return searchDataInstance
    }()
    
    private init() {
        setupManagedObjectContext()
    }
    
    class func shared() -> SearchResultDB {
        return sharedInstance
    }
    
    //set up managed object context
    private func setupManagedObjectContext() {
        let fileManager = FileManager.default
        guard let documentDirectoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("No Directory")
            return
        }
        let persitantUrl = documentDirectoryUrl.appendingPathComponent("MoneyTapTask.sqlite")
        guard let modelUrl = Bundle.main.url(forResource: "MoneyTapTask", withExtension: "momd") else {
            print("No Core data Model momd")
            return
        }
        managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl)
        persistnaceStoreCoodinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            let _ = try persistnaceStoreCoodinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persitantUrl, options: nil)
            managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistnaceStoreCoodinator
            
            readManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            readManagedObjectContext.parent = managedObjectContext
        } catch let exception {
            print("Core data \(exception.localizedDescription)")
        }
    }
    
    //save data function
    fileprivate func saveDataInManagedObjectContextUsing(completionBlock block: @escaping(_ isSaved: Bool)-> Void) {
        do {
            try managedObjectContext.save()
            print("SAVE")
            block(true)
        } catch let error {
            block(false)
            print("Failed to Save data \(error.localizedDescription)")
        }
    }
}

// CoreData request/Queries

extension SearchResultDB {
    
    func saveResults(_ resultModel: ResultModel, _ searchText:String) {
        
        //Fetch Core Data
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PagesDB")
        let predicateID = NSPredicate(format: "title CONTAINS[cd] %@",searchText)
        fetchRequest.predicate = predicateID
        
        var results: [NSManagedObject] = []
        do {
            results = try managedObjectContext.fetch(fetchRequest)
            if results.count == 0 {
                let resultDBObjc = ResultDB(context: managedObjectContext)
                
                if let batchcomplete = resultModel.batchcomplete {
                    resultDBObjc.batchcomplete = batchcomplete
                }
                
                if let query = resultModel.query {
                    let queryDbObjc = QueryDB(context: managedObjectContext)
                    
                    if let pages = query.pages {
                        for page in pages {
                            let pagesDBObjc = PagesDB(context: managedObjectContext)
                            
                            if let id = page.pageid {
                                pagesDBObjc.pageId = Int64(id)
                            }
                            if let title = page.title {
                                pagesDBObjc.title = title
                            }
                            
                            if let terms = page.terms {
                                let termsDBObjc = TermsDB(context: managedObjectContext)
                                if let desc = terms.description {
                                    var i = 0
                                    var message: String!
                                    for des in desc {
                                        if i == 0 {
                                            message =  des
                                        } else {
                                            message.append(" \(des)")
                                        }
                                        i += 1
                                    }
                                    termsDBObjc.wikiDescription = message
                                    pagesDBObjc.setValue(termsDBObjc, forKey: "pageAndTermRelation")
                                    saveDataInManagedObjectContextUsing { (isSaved) in}
                                }
                            }
                            
                            if let thumbnail = page.thumbnail {
                                let thumbnailDBObjc = ThumbnailDB(context: managedObjectContext)
                                if let imagePath = thumbnail.source {
                                    thumbnailDBObjc.source = imagePath
                                    pagesDBObjc.setValue(thumbnailDBObjc, forKey: "pageAndThumbnaiRelation")
                                }
                            }
                            
                            let page = queryDbObjc.value(forKey: "pageQueryRelation")
                            
                            queryDbObjc.setValue(page, forKey: "pageQueryRelation")
                            saveDataInManagedObjectContextUsing { (isSaved) in}
                        }
                    }
                    resultDBObjc.setValue(queryDbObjc, forKey: "resultQueryRelation")
                    saveDataInManagedObjectContextUsing { (isSaved) in}
                }
                saveDataInManagedObjectContextUsing { (isSaved) in}
            }
            else {
                print("Entry already exists")

            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        
       
    }
}

