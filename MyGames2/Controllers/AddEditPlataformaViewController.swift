//
//  AddEditPlataformaViewController.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 30/11/19.
//  Copyright © 2019 Bruno Freire da Silva. All rights reserved.
//

import UIKit
import Photos

class AddEditPlataformaViewController: UIViewController {

    @IBOutlet weak var lbTitulo: UITextField!
    @IBOutlet weak var btSalvarEditar: UIButton!
    @IBOutlet weak var btAddImagem: UIButton!
    @IBOutlet weak var imagem: UIImageView!
    var plataforma: Console!

    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consolesManager.loadConsoles(with: context)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareDataLayout()
    }
    
    func prepareDataLayout() {
       if plataforma != nil {
           title = "Editar plataforma"
           btSalvarEditar.setTitle("ALTERAR", for: .normal)
           lbTitulo.text = plataforma.name
           imagem.image = plataforma.imagem as? UIImage
           if plataforma.imagem != nil {
               btAddImagem.setTitle(nil, for: .normal)
           }
       }
    }

    @IBAction func addImagem(_ sender: Any) {
        print("para adicionar uma imagem da biblioteca")
               
               
       let alert = UIAlertController(title: "Selecinar Foto", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
       
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
       
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
       
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
       
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func AddEditPlataforma(_ sender: Any) {
        if plataforma == nil {
             plataforma = Console(context: context)
           }
           plataforma.name = lbTitulo.text
          
           plataforma.imagem = imagem.image
           
           do {
              try context.save()
           } catch {
              print(error.localizedDescription)
           }
           // Back na navigation
           navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
       
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                   
                    self.chooseImageFromLibrary(sourceType: sourceType)
                   
                } else {
                   
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
           
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }

}


extension AddEditPlataformaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
}


extension AddEditPlataformaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // ImageView won't update with new image
            // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.imagem.image = pickedImage
                self.imagem.setNeedsDisplay()
                self.btAddImagem.setTitle(nil, for: .normal)
                self.btAddImagem.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
