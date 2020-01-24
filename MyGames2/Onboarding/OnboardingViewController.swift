//
//  OnboardingViewController.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 22/01/20.
//  Copyright © 2020 Bruno Freire da Silva. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: [OnboardingCollectionViewCellModel] = []

      override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
            collectionView.isPagingEnabled = true
            
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(gestureApplied))
            gesture.direction = .down
            view.addGestureRecognizer(gesture)
    //        configureButton()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .portrait

         }
    }
    
    @objc func gestureApplied() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
           delegate.orientationLock = .all
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
          delegate.orientationLock = .all
       }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        let row = indexPath.row
        cell.populate(model: datasource[row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
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
