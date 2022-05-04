//
//  ViewController.swift
//  miavv
//
//  Created by Macbook on 27.04.2022.
//

import UIKit
import Foundation
import SDWebImage
import RealmSwift
//import WebKit


class DetailViewController: UIViewController {
    
    //    var webView: WKWebView!
    var detailUrl = String()
    
    var cats = [MiavModel]()
    
    var detailCat = MiavModel()
    
    var favoriteCat: Results<MiavModel>?
    
    //MARK: - Button @IBOutlet

    
    @IBOutlet weak var catsImageView: UIImageView!
    
    @IBOutlet weak var detailCatName: UILabel!
    
    @IBOutlet weak var detailCatDescription: UILabel!
    
    @IBOutlet weak var addFavorite: UIImageView!
    @IBOutlet weak var dogFriendlyLevelLabel: UILabel!
    @IBOutlet weak var intelligenceLevelLabel: UILabel!
    @IBOutlet weak var childFriendlyLevelLabel: UILabel!
    @IBOutlet weak var adaptabilityLevelLabel: UILabel!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var catNameAndFavoriteView: UIView!
    
    @IBOutlet weak var stackViewDetail: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackViewDetail.layer.cornerRadius = stackViewDetail.frame.size.height / 15
        catNameAndFavoriteView.layer.cornerRadius = catNameAndFavoriteView.frame.size.height / 5
        
        addFavorite.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ft_addFavorite))
        addFavorite.addGestureRecognizer(gestureRecognizer)
        
        detailCatName.text = detailCat.name
        detailCatDescription.text = detailCat.descriptionCat
        
        if detailCat.isFavorite == true {
            addFavorite.image = UIImage(named: "addedFavorite")
        }
        
        dogFriendlyLevelLabel.text = ft_starLevel(for: detailCat.dog_friendly)
        intelligenceLevelLabel.text = ft_starLevel(for: detailCat.intelligence)
        childFriendlyLevelLabel.text = ft_starLevel(for: detailCat.child_friendly)
        adaptabilityLevelLabel.text = ft_starLevel(for: detailCat.adaptability)
        
        DispatchQueue.main.async {
            self.catsImageView.sd_setImage(with: URL(string: self.detailCat.url))
        }
        
        ft_LoadFavorite(detailCat.id)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        if detailCat.isFavorite == true {
            
            ft_SaveToFavorite(favoriteCats: detailCat)
        } else {
            
            if let favoriteCat = favoriteCat {
                ft_RemoveFromFavorite(favoriteCat: favoriteCat)
            }
            
        }
        
    }
    
    func ft_LoadFavorite(_ catId: String){
        favoriteCat = realm.objects(MiavModel.self).filter("id == %@", catId)
    }
    
    @objc func ft_addFavorite(){
        
        try! realm.write{ detailCat.isFavorite = !detailCat.isFavorite }
        
        if detailCat.isFavorite == true {
            self.addFavorite.image = UIImage(named: "addedFavorite")
        } else {
            self.addFavorite.image = UIImage(named: "addFavorite")
        }
        
    }
    func ft_starLevel(for value: Int) -> String {
        switch value {
        case 0:
            return "    "
        case 1:
            return "    ⭐️"
        case 2:
            return "    ⭐️⭐️"
        case 3:
            return "    ⭐️⭐️⭐️"
        case 4:
            return "    ⭐️⭐️⭐️⭐️"
        case 5:
            return "    ⭐️⭐️⭐️⭐️⭐️"
        default:
            return "    ??"
        }
    }
    
    func ft_SaveToFavorite(favoriteCats: MiavModel){
        var temp = 0
        
        do{
            try realm.write {
                
                if let favoriteCat = favoriteCat {
                    for i in favoriteCat{
                        if i.id == favoriteCats.id {
                            temp = 1
                        }
                    }
                    if temp != 1{
                        realm.add(favoriteCats)
                    }
                }
            }
            
        } catch {
            print("An error was occured \(error.localizedDescription)")
        }
        
    }
    
    func ft_RemoveFromFavorite(favoriteCat: Results<MiavModel>){
        
        do{
            try realm.write {
                realm.delete(favoriteCat)
            }
            
        } catch {
            print("An error was occured \(error.localizedDescription)")
        }
        
    }
    
}

//MARK: - Web View Function

extension DetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! WebViewController
        destinationVc.url = detailUrl
    }
    
    @IBAction func wikipediaWasTapped(_ sender: Any) {
        detailUrl = detailCat.wikipedia_url
        performSegue(withIdentifier: "toWebView", sender: nil)
        
    }
    @IBAction func vcaWasTapped(_ sender: Any) {
        detailUrl =  detailCat.vcahospitals_url
        performSegue(withIdentifier: "toWebView", sender: nil)
    }
    
}




