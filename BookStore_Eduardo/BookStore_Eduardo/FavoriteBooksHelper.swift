//
//  FavoriteBooks.swift
//  BookStore_Eduardo
//
//  Created by itsector on 01/02/2020.
//  Copyright © 2020 itsector. All rights reserved.
//

import UIKit
import CoreData

class FavoriteBooksHelper {
    
    var favoriteBooks: [String] = []
    
    func addFavorite(bookId: String) {
      
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

      let managedContext = appDelegate.persistentContainer.viewContext

      let entity = NSEntityDescription.entity(forEntityName: "FavoriteBook", in: managedContext)!
      
      let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
      favorite.setValue(bookId, forKeyPath: "id")
      
      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func removeFavorite(bookId: String){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteBook")
        fetchRequest.predicate = NSPredicate(format:"id = %@", bookId)
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let arrUsrObj = try managedContext.fetch(fetchRequest)
            for usrObj in arrUsrObj as! [NSManagedObject] {
                managedContext.delete(usrObj)
            }
           try managedContext.save()
            } catch let error as NSError {
            print("delete fail--",error)
        }
    }
    
    func isFavorite(bookId: String) -> Bool{
        self.getFavorites()
        return favoriteBooks.contains(bookId)
    }
    
    func getFavoritesList() -> [String] {
        self.getFavorites()
        return favoriteBooks
    }
    
    private func getFavorites() {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteBook")
        
        do {
          let response = try managedContext.fetch(fetchRequest)
            favoriteBooks = response.map({ book in
                book.value(forKey: "id") as! String
            })
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
