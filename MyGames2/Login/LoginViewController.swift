//
//  LoginViewController.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 11/01/20.
//  Copyright © 2020 Bruno Freire da Silva. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    var showBoard = true
    var onboardingViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
       // (UIApplication.shared.delegate as! AppDelegate).orientationLock = .all

        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        if(showBoard){
            loadOnboarding(withModels: [
               OnboardingCollectionViewCellModel(title: "The best app ever from login", description: "First app with the new guys", imageName: "background1"),
               OnboardingCollectionViewCellModel(title: "The best app ever from login", description: "First app with the new guys", imageName: "background2")])
        }
       
        // Do any additional setup after loading the view.
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        if newCollection.verticalSizeClass == .compact{
            dismiss(animated: true, completion: nil)

            let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
           let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewControllerCompact") as! LoginViewController
            newViewController.showBoard = false
            self.navigationController?.pushViewController(newViewController, animated: true)

        }
        
        if newCollection.verticalSizeClass == .regular {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            newViewController.showBoard = false
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
           delegate.orientationLock = .all
       }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    private func loadOnboarding(withModels models: [OnboardingCollectionViewCellModel]) {
           if let viewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() as? OnboardingViewController {
               onboardingViewController = viewController
               viewController.datasource = models
               present(viewController, animated: true, completion: nil)
           }

       }
}
