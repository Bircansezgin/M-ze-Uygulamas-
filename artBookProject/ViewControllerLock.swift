//
//  ViewControllerLock.swift
//  artBookProject
//
//  Created by Bircan Sezgin on 9.01.2023.
//

import UIKit

class ViewControllerLock: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        if self.username.text == "" {
            makeAlert(titleİnput: "username Erorr!", massage: "username not Found!")
            
        }
        if self.pass.text == "" {
            makeAlert(titleİnput: "Password Erorr!", massage: "Password not Found!")
            
        }
        
        if self.pass.text == "" && self.username.text == ""{
            makeAlert(titleİnput: "İnput Error", massage: "Not found")
        }
        
        if self.pass.text == "1" && self.username.text == "1"{
            makeAlertOpen(titleİnput: "Success", massage: "Giriş Başarılı")
        }
        
        
    }
    
    // uyarı Fonksiyonu Yapımı!
    func makeAlert(titleİnput: String, massage: String) {
        let alert = UIAlertController(title: titleİnput, message: massage, preferredStyle: UIAlertController.Style.alert)
        let okButton =  UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    // giriş Foksiyonu
    func makeAlertOpen(titleİnput: String, massage: String) {
        let alert = UIAlertController(title: titleİnput, message: massage, preferredStyle: UIAlertController.Style.alert)
        let okButton =  UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
            self.performSegue(withIdentifier: "go3", sender: nil)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    


}
