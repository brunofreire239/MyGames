//
//  AddEditViewController.swift
//  MyGames2
//
//  Created by Bruno Freire da Silva on 30/11/19.
//  Copyright © 2019 Bruno Freire da Silva. All rights reserved.
//

import UIKit
import Photos

class AddEditViewController: UIViewController {

    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtPlataforma: UITextField!
    @IBOutlet weak var data: UIDatePicker!
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var btAdicionarImagem: UIButton!
    @IBOutlet weak var btSalvarEditar: UIButton!
    
    var game: Game!
    
    
     // tip. Lazy somente constroi a classe quando for usar
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consolesManager.loadConsoles(with: context)
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareDataLayout()
    }
    
    func prepareDataLayout(){
        if game != nil {
                   title = "Editar jogo"
                   btSalvarEditar.setTitle("ALTERAR", for: .normal)
                   txtNome.text = game.title
                  
                   // tip. alem do console pegamos o indice atual para setar o picker view
                   if let console = game.console, let index = consolesManager.consoles.index(of: console) {
                       txtPlataforma.text = console.name
                       pickerView.selectRow(index, inComponent: 0, animated: false)
                   }
                   imagem.image = game.cover as? UIImage
                   if let releaseDate = game.releaseDate {
                       data.date = releaseDate
                   }
                   if game.cover != nil {
                       btAdicionarImagem.setTitle(nil, for: .normal)
                   }
               }
              
               let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
               toolbar.tintColor = UIColor(named: "main")
               let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
               let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
               let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
               toolbar.items = [btCancel, btFlexibleSpace, btDone]
              
               // tip. faz o text field exibir os dados predefinidos pela picker view
               txtPlataforma.inputView = pickerView
               txtPlataforma.inputAccessoryView = toolbar
    }
    
    @objc func cancel() {
         txtPlataforma.resignFirstResponder()
     }
    
     @objc func done() {
         txtPlataforma.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
         cancel()
     }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func AddEditImage(_ sender: Any) {
        print("para adicionar uma imagem da biblioteca")
        
        
        let alert = UIAlertController(title: "Selecinar capa", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
        
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
    
    @IBAction func addEditGame(_ sender: Any) {
        
        if game == nil {
          game = Game(context: context)
        }
        game.title = txtNome.text
        game.releaseDate = data.date
        
        if !txtPlataforma.text!.isEmpty{
             let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
                  game.console = console
            }
        game.cover = imagem.image
        
        do {
           try context.save()
            NotificationCenter.default.post(name: NSNotification.Name("atualizar"), object: nil)
        } catch {
           print(error.localizedDescription)
        }
        // Back na navigation
        navigationController?.popViewController(animated: true)
    }
}


extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
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


extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                self.btAdicionarImagem.setTitle(nil, for: .normal)
                self.btAdicionarImagem.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
