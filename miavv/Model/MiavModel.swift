//
//  CatsData.swift
//  miavv
//
//  Created by Macbook on 28.04.2022.
//

import Foundation
import RealmSwift

class MiavModel: Object {
    
    @objc dynamic var id: String = String()
    @objc dynamic var name: String = String()
    @objc dynamic var descriptionCat: String = String()
    @objc dynamic var origin: String = String()
    @objc dynamic var url: String = String()
    @objc dynamic var temperament: String = String()
    @objc dynamic var time_lapse: String = String()
    @objc dynamic var reference_image_id: String = String()
    
    @objc dynamic var adaptability: Int = Int()
    @objc dynamic var child_friendly: Int = Int()
    @objc dynamic var dog_friendly: Int = Int()
    @objc dynamic var intelligence: Int = Int()
    
    @objc dynamic var vcahospitals_url: String = String()
    @objc dynamic var wikipedia_url: String = String()
    
    @objc dynamic var isFavorite: Bool = false
}

