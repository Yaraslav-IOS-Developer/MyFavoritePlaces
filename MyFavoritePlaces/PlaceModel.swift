//
//  PlaceModel.swift
//  MyFavoritePlaces
//
//  Created by Yaroslav on 2.02.21.
//

import UIKit


struct Place {
    
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var restaurantImage: String?
    
    
    static let restaurantName = [
        "Burger Heroes", "Kitchen", "Bonsai",
        "Дастархан", "Индокитай", "X.O", "Балкан Гриль",
        "Sherlock Holmes", "Speak Easy", "Morris Pub",
        "Вкусные истории", "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    
   static func getPlaces() -> [Place] {
        var places = [Place]()
        
        for place in restaurantName {
            places.append(Place(name: place, location: "Минск", type: "Ресторан", restaurantImage: place))
        }
        
        return places
    }
}
