//
//  GamesTableViewController.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 30/11/19.
//  Copyright © 2019 Bruno Freire da Silva. All rights reserved.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {
        
    

    var label = UILabel()
    // mensagem default
    
    var primeiroAcesso = false
    
    let searchController = UISearchController(searchResultsController: nil)

    var fetchedResultController: NSFetchedResultsController<Game>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        NotificationCenter.default.addObserver(self, selector: #selector(atualizar), name: NSNotification.Name("atualizar"), object: nil)

        label.text = "Você não tem jogos cadastrados"
        label.textAlignment = .center
         // altera comportamento default que adicionava background escuro sobre a view principal
          searchController.dimsBackgroundDuringPresentation = false
          searchController.obscuresBackgroundDuringPresentation = false
          searchController.searchBar.tintColor = .white
          searchController.searchBar.barTintColor = .white
         
          navigationItem.searchController = searchController
         
          // usando extensions
          searchController.searchBar.delegate = self
          searchController.searchResultsUpdater = self
        
        
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        
        if(primeiroAcesso){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
        }else{
            loadGames()
        }
       // loadGames()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
              delegate.orientationLock = .portrait
       }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
           if segue.identifier! == "gameSegue" {
               print("gameSegue")
               let vc = segue.destination as! GameViewController
               
               if let games = fetchedResultController.fetchedObjects {
                   vc.game = games[tableView.indexPathForSelectedRow!.row]
               }
               
           } else if segue.identifier! == "newGameSegue" {
               print("newGameSegue")
           }
       }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let count = fetchedResultController?.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        return count

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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
           return cell
        }
               
        cell.prepare(with: game)
        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
             if editingStyle == .delete {
              guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
              context.delete(game)
             
              do {
                  try context.save()
              } catch  {
                  print(error.localizedDescription)
              }
          }
    }
    
    //Calling a function using #selector
    @objc private func atualizar() {
        loadGames()
    }

}

extension GamesTableViewController: NSFetchedResultsControllerDelegate {
   
    // sempre que algum objeto for modificado esse metodo sera notificado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
       
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
    }
}

extension GamesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadGames()
        tableView.reloadData()
       
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadGames(filtering: searchBar.text!)
        tableView.reloadData()
    }
}

