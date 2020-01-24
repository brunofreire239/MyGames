//
//  ItemCollectionViewCell.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 23/01/20.
//  Copyright © 2020 Bruno Freire da Silva. All rights reserved.
//

import UIKit


struct ItemCollectionViewCellModel {
    var title: String?
    var description: String?
    var imageName: String?
    
    init(title: String, description: String, imageName: String) {
        self.title = title
        self.description = description
        self.imageName = imageName
    }
}

class ItemCollectionViewCell: UICollectionViewCell {
    
       @IBOutlet weak var lbTitle: UILabel!
       @IBOutlet weak var backgroundImage: UIImageView!
       @IBOutlet weak var lbDescription: UILabel!
       var model: ItemCollectionViewCellModel?

       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }
       
        func prepare(with game: Game) {
           lbTitle.text = game.title ?? ""
           lbDescription.text = game.console?.name ?? ""
           if let image = game.cover as? UIImage {
               backgroundImage.image = image
           } else {
               backgroundImage.image = UIImage(named: "noCover")
           }
       }
}
