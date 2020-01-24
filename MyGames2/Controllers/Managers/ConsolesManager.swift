//
//  Manager.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 30/11/19.
//  Copyright © 2019 Bruno Freire da Silva. All rights reserved.
//

import Foundation


import CoreData
class ConsolesManager {
   
    static let shared = ConsolesManager()
    var consoles: [Console] = []
   
    func loadConsoles(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
       
        do {
            consoles = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
   
   
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console)
       
        do {
            try context.save()
            consoles.remove(at: index)
        } catch  {
            print(error.localizedDescription)
        }
    }
   
    private init() {
       
    }
}
