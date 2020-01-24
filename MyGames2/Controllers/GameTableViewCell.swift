//
//  GameTableViewCell.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 30/11/19.
//  Copyright © 2019 Bruno Freire da Silva. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitulo: UILabel!
    @IBOutlet weak var lbPlataforma: UILabel!
    @IBOutlet weak var imgCapa: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(with game: Game) {
        lbTitulo.text = game.title ?? ""
        lbPlataforma.text = game.console?.name ?? ""
        if let image = game.cover as? UIImage {
            imgCapa.image = image
        } else {
            imgCapa.image = UIImage(named: "noCover")
        }
    }
}
