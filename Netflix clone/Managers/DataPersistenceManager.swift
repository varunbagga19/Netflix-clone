//
//  DataPersistenceManager.swift
//  Netflix clone
//
//  Created by Varun Bagga on 29/12/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DataBaseError:Error{
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
        
    }
    
    static let shared = DataPersistenceManager()
    
    
    func downloadTitleWith(model:Title,completion:@escaping(Result<Void,Error>)->Void){
        
       // below 2 lines are to contact with core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.original_language = model.original_language
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        do{
            try context.save()
            completion(.success(()))//passing void
        }catch{
            completion(.failure(DataBaseError.failedToSaveData))
        }
        
    }
    
    func fetchingTitlesFromDataBase(completion:@escaping(Result<[TitleItem],Error>)->Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request:NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do{
           let titles = try context.fetch(request)
            completion(.success(titles))
        }catch{
            completion(.failure(DataBaseError.failedToFetchData))
            
        }
    }
    
    func deleteTitleWith(model:TitleItem ,completion:@escaping(Result<Void,Error>)->Void){
        // below 2 lines are to contact with core data
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
             return
         }
         
         let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataBaseError.failedToDeleteData))
        }
         
    }
}


