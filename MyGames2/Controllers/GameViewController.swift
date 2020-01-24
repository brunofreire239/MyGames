//
//  ViewController.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 29/11/19.
//  Copyright © 2019 Bruno Freire da Silva. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var lbTitulo: UILabel!
    @IBOutlet weak var lbPlataforma: UILabel!
    @IBOutlet weak var lbData: UILabel!
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var imagemPlataforma: UIImageView!
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        lbTitulo.text = game.title
        lbPlataforma.text = game.console?.name
        if let releaseDate = game.releaseDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            lbData.text = "Lançamento: " + formatter.string(from: releaseDate)
        }
       
        if let image = game.cover as? UIImage {
            imagem.image = image
        } else {
            imagem.image = UIImage(named: "noCoverFull")
        }
        
        if let imagePlataforma = game.console?.imagem as? UIImage {
               imagemPlataforma.image = imagePlataforma
           } else {
               imagemPlataforma.image = UIImage(named: "noCoverFull")
           }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.game = game
    }

}

