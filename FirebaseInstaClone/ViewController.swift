//
//  ViewController.swift
//  FirebaseInstaClone
//
//  Created by Mustafa Kemal ARDA on 6.09.2023.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata,  error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
     
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Username/Password Not Found!")
        }
    
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }

        } else {
            makeAlert(titleInput: "Error!", messageInput: "Username/Password Not Found!")
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
 
}

