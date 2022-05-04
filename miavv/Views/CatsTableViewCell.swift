//
//  CatsTableViewCell.swift
//  miavv
//
//  Created by Macbook on 28.04.2022.
//

import UIKit

class CatsTableViewCell: UITableViewCell {
    @IBOutlet weak var catCellBuble: UIView!
    
    @IBOutlet weak var tempramentLabel: UILabel!
    @IBOutlet weak var timeLapseLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBOutlet weak var catNameLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        favoriteImageView.isHidden = true
        catCellBuble.layer.cornerRadius = catCellBuble.frame.size.height / 5
        catImageView.layer.cornerRadius = catImageView.frame.size.height / 5
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
