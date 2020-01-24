//
//  CollectionViewController.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 23/01/20.
//  Copyright © 2020 Bruno Freire da Silva. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController {
    
    var label = UILabel()

    @IBOutlet weak var collectionView: UICollectionView!
    var fetchedResultController: NSFetchedResultsController<Game>!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(atualizar), name: NSNotification.Name("atualizar"), object: nil)

        label.text = "Você não tem jogos cadastrados"
        label.textAlignment = .center
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCollectionViewCell")
       collectionView.isPagingEnabled = true
       loadGames()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
          delegate.orientationLock = .all

       }
    }
    
    // valor default evita precisar ser obrigado a passar o argumento quando chamado
    func loadGames(filtering: String = "") {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
       
        if !filtering.isEmpty {
            // usando predicate: conjunto de regras para pesquisas
            // contains [c] = search insensitive (nao considera letras identicas)
            let predicate = NSPredicate(format: "title contains [c] %@", filtering)
            fetchRequest.predicate = predicate
        }
       
        // possui
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
       
        do {
            try fetchedResultController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    @objc private func atualizar() {
        loadGames()
    }

}



extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
      
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
          return cell
       }
              
       cell.prepare(with: game)
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = fetchedResultController?.fetchedObjects?.count ?? 0
               collectionView.backgroundView = count == 0 ? label : nil
       return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CollectionViewController: NSFetchedResultsControllerDelegate {
   
    // sempre que algum objeto for modificado esse metodo sera notificado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
       
        collectionView.reloadData()
        
    }
}

