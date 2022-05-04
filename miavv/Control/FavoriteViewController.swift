//
//  FavoriteViewController.swift
//  miavv
//
//  Created by Macbook on 1.05.2022.
//

import UIKit
import RealmSwift

class FavoriteViewController: UITableViewController {
    
    
    var favoriteCatsArray: Results<MiavModel>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CatsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReuseCatCell")
        
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor(named: "backRoundColor")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        ft_LoadFavorite()

    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteCatsArray?.realm?.refresh()

        return favoriteCatsArray?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ft_CustomCell(for: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailVCFromFavorite", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let favoriteCatsArray = favoriteCatsArray {
            
                let destinationVC = segue.destination as! DetailViewController
                if let indexPath = tableView.indexPathForSelectedRow{
                    destinationVC.detailCat = favoriteCatsArray[indexPath.row]
                }
        }
        
    }
    
    func ft_CustomCell(for indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseCatCell") as! CatsTableViewCell
        
        if let favoriteCatsArray = favoriteCatsArray {
            
            
            if (favoriteCatsArray[indexPath.row].isFavorite == true) {
                cell.favoriteImageView.isHidden = false
            } else {
                cell.favoriteImageView.isHidden = true
            }
            
            cell.catNameLabel.text = favoriteCatsArray[indexPath.row].name
            cell.originLabel.text = favoriteCatsArray[indexPath.row].origin
            cell.timeLapseLabel.text = favoriteCatsArray[indexPath.row].time_lapse
            cell.tempramentLabel.text = favoriteCatsArray[indexPath.row].temperament
            
            DispatchQueue.main.async {
                
                cell.catImageView.sd_setImage(with: URL(string: favoriteCatsArray[indexPath.row].url), placeholderImage: UIImage(named: "placeHolderCat"))
            
        }
        }
        
        return cell
    }
    
    func ft_LoadFavorite(){
        
        favoriteCatsArray = realm.objects(MiavModel.self).filter("isFavorite == YES ")
        tableView.reloadData()
        
    }
    
}
