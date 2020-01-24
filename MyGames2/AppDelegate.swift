//
//  AppDelegate.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 29/11/19.
//  Copyright © 2019 Bruno Freire da Silva. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        if let viewController = storyboard.instantiateInitialViewController() {
//            window = UIWindow()
//            self.window?.rootViewController = viewController
//        }
        self.setLoginToRootViewController()

        
        return false
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyGames2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
           return self.orientationLock
       }

}


extension AppDelegate{
    func setLoginToRootViewController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let initialViewController =  storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    static var shared: AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: UINavigationController{
        return window!.rootViewController as! UINavigationController
    }
}
