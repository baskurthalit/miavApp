//
//  CatsTableViewController.swift
//  miavv
//
//  Created by Macbook on 27.04.2022.
//

import UIKit
import SDWebImage
import RealmSwift

class CatsTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var miavManager = MiavManager()
    var cats = [MiavModel]()
    
    @IBAction func favoriteWasTapped(_ sender: Any) {
        performSegue(withIdentifier: "toFavoriteView", sender: nil)
    }
}
//MARK: - CatsTableViewController LifeCycle Function

extension CatsTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.barTintColor = UIColor(named: "backRoundColor")
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor(named: "backRoundColor")
        
        miavManager.delegate = self
        
        tableView.register(UINib(nibName: "CatsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReuseCatCell")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.text = ""
        DispatchQueue.main.async {
            self.miavManager.ft_FetchCats()
        }
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
//                cats.removeAll()
    }
    
}
// MARK: - Table view data source
extension CatsTableViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return ft_CustomCell(for: indexPath)
    }
    
    func ft_CustomCell(for indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseCatCell") as! CatsTableViewCell
        if (self.cats[indexPath.row].isFavorite == true) {
            cell.favoriteImageView.isHidden = false
        } else {
            cell.favoriteImageView.isHidden = true
        }
        
        cell.catNameLabel.text = cats[indexPath.row].name
        cell.originLabel.text = cats[indexPath.row].origin
        cell.timeLapseLabel.text = cats[indexPath.row].time_lapse
        cell.tempramentLabel.text = cats[indexPath.row].temperament
        
        DispatchQueue.main.async {
            
            cell.catImageView.sd_setImage(with: URL(string: self.cats[indexPath.row].url), placeholderImage: UIImage(named: "placeHolderCat"))
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.detailCat = self.cats[indexPath.row]
            }
        }
    }
}
//MARK: - MiavManagerDelegate

extension CatsTableViewController: MiavManagerDelegate {
    
    func didUpdateCat(_ miavManager: MiavManager, CatsData cats : [MiavModel]) {
        
        self.cats = cats
        
        self.tableView.reloadData()
        
    }
    func didFailWithError(error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    
}

//MARK: - UISearchBarDelegate

extension CatsTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.miavManager.ft_FetchCats(by: searchBar.text!)
        self.tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            self.miavManager.ft_FetchCats()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
