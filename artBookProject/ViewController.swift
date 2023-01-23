//
//  ViewController.swift
//  artBookProject
//
//  Created by Bircan Sezgin on 26.12.2022.
//
// Kullanıcı Adı Şifre ile giriş Yapılıcak. 

import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var nameArray = [String]()
    var idArray = [UUID]()
  
    
    var selectedPaint = ""
    var selectedPaintID = UUID()
    
 
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        tableView.delegate = self
        tableView.dataSource = self
        
        // + button oluşturduk..
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addbuttonClick))
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    
    
    @objc func getData() {
        
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegete = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegete.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageS")
        fetchRequest.returnsObjectsAsFaults = false // Cacsh'işlemleri ile false Yapınca hızdan kazanıyoruz
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "name") as? String{
                        self.nameArray.append(name)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID{
                        self.idArray.append(id)
                    }
                    
                    self.tableView.reloadData()
                }
            }

            
            
        }catch {
            print("Hata")
        }
        
        
        
    }

    
    @objc func addbuttonClick(){
        selectedPaint = ""
        performSegue(withIdentifier: "go2", sender: nil)
    }
    
    // Row Satırlarını Ekledim.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    // her rowun içinde ne oluyordu
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var context = cell.defaultContentConfiguration()
        context.text = nameArray[indexPath.row]
        cell.contentConfiguration = context
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPaint = nameArray[indexPath.row]
        selectedPaintID = idArray[indexPath.row]
        performSegue(withIdentifier: "go2", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2"{
            let git = segue.destination as! ViewController2
            git.chosenPaint = selectedPaint
            git.chosenPaintID = selectedPaintID
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageS")
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate (format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if let id = result.value(forKey: "id") as? UUID{
                            if id == idArray[indexPath.row]{
                                context.delete(result)
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                
                                    do {
                                        try context.save()
                                    }catch{
                                        print("error")
                                    }
                                    break
                                }
                            }
                        }
                    }
                }catch {
                    print("Error")
            }
            
        }
 
    }
    
    
    



}

