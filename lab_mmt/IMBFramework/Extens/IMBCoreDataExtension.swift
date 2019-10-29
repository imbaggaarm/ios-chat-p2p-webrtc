//
//  CoreDataExtension.swift
//  AppCoreDataTempSwift
//
//  Created by Tai Duong on 1/10/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//extension UIViewController
//{
//    //SAVE
//    func coreDataSave(managedObjectContext: NSManagedObjectContext)
//    {
//        do
//        {
//            try managedObjectContext.save()
//            //print("excuted success")
//        }
//        catch
//        {
//            print(error, error.localizedDescription)
//        }
//    }
//    
//    //UPDATE
//    func coreDataUpdate(context: NSManagedObjectContext)
//    {
//        coreDataSave(managedObjectContext: context)
//    }
//    
//    //LOAD
//    //non fetch Request
//    func coreDataLoadAllObjects(of entity: String, in context: NSManagedObjectContext) -> Array<NSManagedObject>
//    {
//        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
//        return coreDataLoadObjectsWithFetchRequests(with: fetch, in: context)
//    }
//    
//    
//    //with fetch request
//    func coreDataLoadObjectsWithFetchRequests(with fetch: NSFetchRequest<NSFetchRequestResult>, in context: NSManagedObjectContext) -> Array<NSManagedObject>
//    {
//        var resultArray = [NSManagedObject]()
//        do
//        {
//            let tempResultArray = try context.fetch(fetch)
//            for i in tempResultArray
//            {
//                if let object = i as? NSManagedObject
//                {
//                    resultArray.append(object)
//                }
//            }
//            //print("load success")
//        }
//        catch
//        {
//            print("load data failed with error: \(error), descriptions: " + error.localizedDescription)
//        }
//        //print("loaded: \(resultArray.count) objects")
//        return resultArray
//    }
//    
//    //DELETE
//    //one
//    func coreDataDeleteObject(object: NSManagedObject, in context: NSManagedObjectContext)
//    {
//        context.delete(object)
//        do
//        {
//            try context.save()
//            //print("delete object succeeded")
//        }
//        catch
//        {
//            print("failed to delete object with error \(error), descriptions:", error.localizedDescription)
//        }
//    }
//    //all in one
//    func coreDataDeleteAllObjects(from entity: String, in context: NSManagedObjectContext)
//    {
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: entity))
//        do
//        {
//            try context.execute(deleteRequest)
//            //print("delete all data from \(entity) succeeded")
//        }
//        catch
//        {
//            print("failed to delete all data with error \(error), descriptions", error.localizedDescription)
//        }
//    }
//    
//    //all in many
//    func coreDataDeleteAllObjectsFromEnities(from entities: [String], in context: NSManagedObjectContext)
//    {
//        for entity in entities
//        {
//            coreDataDeleteAllObjects(from: entity, in: context)
//        }
//    }
//    
//    func coreDataGetManagedObjectContext() -> NSManagedObjectContext
//    {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        return (appDelegate?.viewContext)!
//    }
//}

//class IMBCoreData: NSObject {
//    static let shared = IMBCoreData()
//
//    func getManagedObjectContext() -> NSManagedObjectContext
//    {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        return (appDelegate?.managedObjectContext)!
//    }
//    //SAVE
//    func coreDataSave(managedObjectContext: NSManagedObjectContext)
//    {
//        do
//        {
//            try managedObjectContext.save()
//            //print("excuted success")
//        }
//        catch
//        {
//            print(error, error.localizedDescription)
//        }
//    }
//
//    //UPDATE
//    func coreDataUpdate(context: NSManagedObjectContext)
//    {
//        coreDataSave(managedObjectContext: context)
//    }
//
//    //LOAD
//    //non fetch Request
//    func coreDataLoadAllObjects(of entity: String, in context: NSManagedObjectContext) -> Array<NSManagedObject>
//    {
//        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
//        return coreDataLoadObjectsWithFetchRequests(with: fetch, in: context)
//    }
//
//
//    //with fetch request
//    func coreDataLoadObjectsWithFetchRequests(with fetch: NSFetchRequest<NSFetchRequestResult>, in context: NSManagedObjectContext) -> Array<NSManagedObject>
//    {
//        var resultArray = [NSManagedObject]()
//        do
//        {
//            let tempResultArray = try context.fetch(fetch)
//            for i in tempResultArray
//            {
//                if let object = i as? NSManagedObject
//                {
//                    resultArray.append(object)
//                }
//            }
//            //print("load success")
//        }
//        catch
//        {
//            print("load data failed with error: \(error), descriptions: " + error.localizedDescription)
//        }
//        //print("loaded: \(resultArray.count) objects")
//        return resultArray
//    }
//
//    //DELETE
//    //one
//    func coreDataDeleteObject(object: NSManagedObject, in context: NSManagedObjectContext)
//    {
//        context.delete(object)
//        do
//        {
//            try context.save()
//            //print("delete object succeeded")
//        }
//        catch
//        {
//            print("failed to delete object with error \(error), descriptions:", error.localizedDescription)
//        }
//    }
//    //all in one
//    func coreDataDeleteAllObjects(from entity: String, in context: NSManagedObjectContext)
//    {
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: entity))
//        do
//        {
//            try context.execute(deleteRequest)
//            //print("delete all data from \(entity) succeeded")
//        }
//        catch
//        {
//            print("failed to delete all data with error \(error), descriptions", error.localizedDescription)
//        }
//    }
//
//    //all in many
//    func coreDataDeleteAllObjectsFromEnities(from entities: [String], in context: NSManagedObjectContext)
//    {
//        for entity in entities
//        {
//            coreDataDeleteAllObjects(from: entity, in: context)
//        }
//    }
//
//}


