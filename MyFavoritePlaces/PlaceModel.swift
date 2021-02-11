//
//  PlaceModel.swift
//  MyFavoritePlaces
//
//  Created by Yaroslav on 2.02.21.
//

import RealmSwift


class Place: Object {
    
    @objc var name = ""
    @objc var location: String?
    @objc var type: String?
    @objc var imageData: Data?
    
    
    
    let restaurantName = [
        "Burger Heroes", "Kitchen", "Bonsai",
        "Дастархан", "Индокитай", "X.O", "Балкан Гриль",
        "Sherlock Holmes", "Speak Easy", "Morris Pub",
        "Вкусные истории", "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    
   func savePlaces() {
        
        
        for place in restaurantName {
            let image = UIImage(named: place)
            guard let imageData = image?.pngData() else { return }
            
            
            let newPlace = Place()
            newPlace.name = place
            newPlace.location = "Minsk"
            newPlace.type = "Restaurant"
            newPlace.imageData = imageData
            
            StorageManager.saveObject(newPlace)
            
        }
        
    }
}
