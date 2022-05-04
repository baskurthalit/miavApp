//
//  miavController.swift
//  miavv
//
//  Created by Macbook on 27.04.2022.
//

import Foundation
import SwiftyJSON
import RealmSwift


protocol MiavManagerDelegate {
    func didUpdateCat(_ miavManager: MiavManager, CatsData cats: [MiavModel])
    func didFailWithError(error: Error)
    
}

struct MiavManager{
    let realm = try! Realm()

    
    let headers = ["x-api-key": "34455a0b-be8b-4d70-a55f-a4449668138c"]

    var delegate: MiavManagerDelegate?
    
}
//MARK: - MiavManager Fetch and Parse Json Data

extension MiavManager{
    
    mutating func ft_FetchCats(by breedName:String = ""){
        
        var breedUrl: String = ""
        if breedName != "" {
            breedUrl = "https://api.thecatapi.com/v1/breeds/search?q=\(breedName)"
        }else {
            breedUrl = "https://api.thecatapi.com/v1/breeds"
        }
        ft_PerformRequest(with: breedUrl)

    }
    
    func ft_PerformRequest(with breedUrl: String){
        let request = NSMutableURLRequest(url: NSURL(string: breedUrl )! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request as URLRequest) {  (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            if let safeData = data {
                DispatchQueue.main.async {
                    
                    if let cat = self.ft_ParseJson(safeData){
                        self.delegate?.didUpdateCat(self, CatsData: cat)
                    }
                }
            }
            
        }
        dataTask.resume()
        
    }
    
    func ft_ParseJson(_ data:Data) -> [MiavModel]? {
        
        var catArray = [MiavModel]()
        
        do{
            let json = try JSON(data: data)
            if json.count != 0{
                catArray.removeAll()
                for i in 0...(json.count-1) {
                    let newCat = MiavModel()
                    
                    newCat.name = json[i]["name"].stringValue
                    newCat.id = json[i]["id"].stringValue
                    newCat.descriptionCat = json[i]["description"].stringValue
                    newCat.origin = json[i]["origin"].stringValue
                    
                    newCat.intelligence = json[i]["intelligence"].intValue
                    newCat.adaptability = json[i]["adaptability"].intValue
                    newCat.child_friendly = json[i]["child_friendly"].intValue
                    newCat.dog_friendly = json[i]["dog_friendly"].intValue
                    
                    newCat.url = json[i]["image"]["url"].stringValue
                    newCat.vcahospitals_url = json[i]["vcahospitals_url"].stringValue
                    newCat.wikipedia_url = json[i]["wikipedia_url"].stringValue
                    
                    newCat.time_lapse = json[i]["life_span"].stringValue
                    newCat.temperament = json[i]["temperament"].stringValue
                    newCat.reference_image_id = json[i]["reference_image_id"].stringValue
                    
                    if newCat.url == "" {
                        newCat.url = "https://cdn2.thecatapi.com/images/\(newCat.reference_image_id).png?api_key=34455a0b-be8b-4d70-a55f-a4449668138c"
                        
                    }
                    
                    let favoriteCat = realm.objects(MiavModel.self).filter("id == %@", newCat.id)
                    
                    if(favoriteCat.count >= 1){
                        newCat.isFavorite = true
                        catArray.append(newCat)
                        
                    } else {
                        newCat.isFavorite = false
                        catArray.append(newCat)
                    
                    }
                    
                }
                
            }
            return catArray
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}





//https://api.thecatapi.com/v1/breeds?attach_breed=0?api_key=34455a0b-be8b-4d70-a55f-a4449668138c
//https://api.thecatapi.com/v1/images/search?breed_ids=beng?api_key=34455a0b-be8b-4d70-a55f-a4449668138c


