//
//  UploadViewController.swift
//  FirebaseInstaClone
//
//  Created by Mustafa Kemal ARDA on 7.09.2023.
//

import UIKit
import Firebase
import FirebaseStorage


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButtonClicked: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        selectImage.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPicture))
        selectImage.addGestureRecognizer(imageTapRecognizer)
        
    }
    

    @objc func selectPicture() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectImage.image = info[.originalImage] as? UIImage
        uploadButtonClicked.isEnabled = true
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
   
    }
    

    // Firebase'de bulunan media klasörüne erişim sağlar
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        
        if let data = selectImage.image?.jpegData(compressionQuality: 0.5) {        // fotoğrafın boyutunu küçültme işlemi
            
            
            let uuid = UUID().uuidString            // her fotoğrafa ayrı bir string atar
            
            // fotoğrafı string'e dönüştürür
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                } else {
                    
                    imageReference.downloadURL { (url, error) in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            
                            // DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                                    
                                } else {
                                    
                                    self.selectImage.image = UIImage(named: "selectimage")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0        // tabbar'da feed sayfasına yönlendirir
                                    
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
