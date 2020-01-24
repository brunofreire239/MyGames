//
//  OnboardingCollectionViewCell.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 22/01/20.
//  Copyright © 2020 Bruno Freire da Silva. All rights reserved.
//

import UIKit

struct OnboardingCollectionViewCellModel {
    var title: String?
    var description: String?
    var imageName: String?
    
    init(title: String, description: String, imageName: String) {
        self.title = title
        self.description = description
        self.imageName = imageName
    }
}

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    var model: OnboardingCollectionViewCellModel?
      
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(model: OnboardingCollectionViewCellModel) {
         self.model = model
         lbTitle.text = model.title
         lbDescription.text = model.description
         
         if let imageName = model.imageName {
             backgroundImage.image = UIImage(named: imageName)
         }
     }
}
