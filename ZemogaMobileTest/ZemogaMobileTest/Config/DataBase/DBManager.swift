//
//  DBManager.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 6/02/22.
//

import Foundation
import RealmSwift

class DBManager{
    //Mar: - Properties
    static let shared = DBManager()
    let realm = try! Realm()
    
    private init(){}
    
    
    func addPostDB(posts:[RealmPost]){
        do{
            try realm.write{
                realm.add(posts)
            }
        }catch let error as NSError{
            print("Realm ERROR - Adding post: \(error)")
        }
    }
    
    func checkPostAsReadDB(post: RealmPost){
        do {
            try realm.write {
                post.wasRead = true
            }
        } catch let error as NSError {
            print("Realm ERROR - Marking post as read: \(error)")
        }
    }
    
    func deletePostDB(post: RealmPost){
        do{
            try realm.write{
                realm.delete(post)
            }
        }catch let error as NSError{
            print("Realm ERROR - Delete individual post: \(error)")
        }
    }
    
    func deleteAllDB(posts:[RealmPost]){
        do{
            try realm.write{
                realm.delete(posts)
            }
        }catch let error as NSError{
            print("Realm ERROR - Deleting all: \(error)")
        }
    }
    
    func fetchPostsDB() -> [RealmPost]{
        do{
            let realm = try Realm()
            return Array(realm.objects(RealmPost.self))
        }catch let error as NSError{
            print("Realm ERROR - Updating a post: \(error)")
        }
        
        return[RealmPost]()
    }
    
    func addPostToFavoritesDB(post: RealmPost, isFavorite: Bool){
        do {
            try realm.write {
                post.isFavorite = isFavorite
            }
        } catch let error as NSError {
            print("Realm ERROR - Adding post to favorites: \(error)")
        }
    }
    
}
