//
//  SettingsViewController.swift
//  FirebaseInstaClone
//
//  Created by Mustafa Kemal ARDA on 7.09.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("Error!")
        }
        
    }
    
}
