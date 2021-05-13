//
//  StorageManager.swift
//  MyFavoritePlaces
//
//  Created by Yaroslav on 11.02.2021.
//

import  RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deletObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
