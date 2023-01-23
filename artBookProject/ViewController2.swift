//
//  ViewController2.swift
//  artBookProject
//
//  Created by Bircan Sezgin on 26.12.2022.
//

import UIKit
import CoreData

class ViewController2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    
    
    var chosenPaint = ""
    var chosenPaintID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenPaint != ""{
            // Core Data
            let appDelegete = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegete.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageS")
            
            let idString = chosenPaintID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String{
                            nameText.text = name
                        }
                        
                        if let artist = result.value(forKey: "artist") as? String{
                            artistText.text = artist
                        }
                        
                        if let year = result.value(forKey: "year") as? Int{
                            dateText.text = String(year) 
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data{
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                    }
                }
            }catch{
                
            }
            
            
            
        }else{
            nameText.text = ""
            artistText.text = ""
            dateText.text = ""
        }

        //Recognizer
        
        //klayve kapat
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyborad))
        view.addGestureRecognizer(gestureRecognizer)
        
        // Kullacınıcı Göresele tıklayabiliyor mu?
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
        
    }
    
    // Klavye kapat
    @objc func hideKeyborad(){
        view.endEditing(true)
    }
    
    // Fotoğrafa basınca Galarinin açılması için gereken kodlar. !!! 1-
    @objc func selectImage(){
        let picker = UIImagePickerController()
        // yukarı Kalıtım özelliği ile Sınıf ekledik.
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // Görseli seçtikten Sonra ne olsun? !!! 2-
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage // bizden image beklediği için bizde as? cast Ettik
        self.dismiss(animated: true)
    }
    
    
    
    // Butonu navbar'a koy
    
    // DataBase'e kaydetmek için yapılmadı gereknler.
    @IBAction func saveButton(_ sender: Any) {
        // AppDelegete'i Segue Destinationda yapyığımız gibi yapyıoruz (Değişkne- Obje)
        let appDelegete = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegete.persistentContainer.viewContext
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "ImageS", into: context)
        
        // Attributes - artkBookProject'in içinde tanımladığımız Attributlar.
        newPainting.setValue(nameText.text!, forKey: "name")
        newPainting.setValue(artistText.text!, forKey: "artist")
        if let year = Int(dateText.text!){
            newPainting.setValue(year, forKey: "year")
        }
        newPainting.setValue(UUID(), forKey: "id")
        
        // Görseli UIImage nasıl dataya çevirili
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        newPainting.setValue(data, forKey: "image")
        
        // Hata olursa ne yapılıcak. Onu yazıyoruz!!
        do{
            try context.save()
            print("Success")
        } catch{
            print("Erorr")
        }
        
    
        // Tüm app'in içinde "newData diye bir data yolluyoruz. Sonra bunu yakalayıp istediğimizi yaptırıyoruz."
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
         
    }
    
 

}
