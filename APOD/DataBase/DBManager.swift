//
//  DBManager.swift
//  APOD
//
//  Created by Venkatesh S on 17/04/22.
//

import Foundation
import UIKit
import CoreData

class DBManager{
    
    static let shared = DBManager()
    private init(){}
    
    
    func save(apod: APODModel) {
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      let managedContext =
        appDelegate.persistentContainer.viewContext
      let entity =
        NSEntityDescription.entity(forEntityName: "APOD",
                                   in: managedContext)!
      let articleToSave = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        articleToSave.setValue(apod.title, forKeyPath: "title")
        articleToSave.setValue(apod.explanation, forKeyPath: "explanation")
        articleToSave.setValue(apod.hdurl, forKeyPath: "hdurl")
        articleToSave.setValue(apod.media_type, forKeyPath: "media_type")
        articleToSave.setValue(apod.date, forKeyPath: "date")
        
      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func getsavedAPOD() -> [APODModel]{
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return []
          }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "APOD")

          do {
            let apods = try managedContext.fetch(fetchRequest)
            return self.returnSavedAPOD(data: apods)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
          }
    }
    func returnSavedAPOD(data : [NSManagedObject]) -> [APODModel]{
        var returnedAPOD : [APODModel] = []
        for article in data {
            var savedAPOD = APODModel()
            savedAPOD.title = article.value(forKey: "title") as? String ?? ""
            savedAPOD.explanation = article.value(forKey: "explanation") as? String ?? ""
            savedAPOD.hdurl = article.value(forKey: "hdurl") as? String ?? ""
            savedAPOD.media_type = article.value(forKey: "media_type") as? String ?? ""
            savedAPOD.date = article.value(forKey: "date") as? String ?? ""
            returnedAPOD.append(savedAPOD)
        }
        return returnedAPOD
    }
    func checkIfItemExist(date: String) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return false
          }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "APOD")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "date == %@" ,date)
        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    func deleteAPOD(date:String)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "APOD")
        fetchRequest.predicate = NSPredicate(format: "date = %@", "\(date)")
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0 {
                let apods = try managedContext.fetch(fetchRequest)
                for entity in apods {
                    managedContext.delete(entity)
                }
            }else {
                return
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return
        }

    }
}


