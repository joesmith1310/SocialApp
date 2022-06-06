//
//  createNewUserViewController.swift
//  socialApp1
//
//  Created by Joe Smith on 04/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class createNewUserViewController: UIViewController {
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    @IBAction func signInPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignIn", sender: self)
        
    }
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var errorBox: UILabel!

    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage!
    
    func storUserData(userId: String) {
        
        //ref.child("users").child(userId).child("userData").updateChildValues(["userCode": "00.00.00.00"])
        
        if let username = usernameField.text {
            ref.child("users").child(userId).child("userData").updateChildValues(["username": username])
            
        }
        
        if selectedImage != nil {
            guard let imageData: Data = selectedImage.jpegData(compressionQuality: 0.2) else {
                return
            }

            let metaDataConfig = StorageMetadata()
            metaDataConfig.contentType = "image/jpg"

            let storageRef = Storage.storage().reference(withPath: userId).child("userImg")

            storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)

                    return
                }

                storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                    self.ref.child("users").child(userId).child("userData").updateChildValues(["userImg": url?.absoluteString as Any])
                })
            }
        }
        
        
        
    }
    
    @IBAction func createNewUserPressed(_ sender: UIButton) {
        if selectedImage != nil {
            if let email = emailField.text, let password = passwordField.text {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if authResult != nil {
                        self.storUserData(userId: (authResult?.user.uid)!)
                        self.performSegue(withIdentifier: "toSignIn", sender: self)
                    }
                    else {
                        self.errorBox.text = error?.localizedDescription
                    }
                }
            }
        }
        else {
            self.errorBox.text = "You must add a user image."
        }
    }
    
    @IBAction func getPhoto(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}

extension createNewUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImage.layer.cornerRadius = userImage.frame.height/2
            userImage.clipsToBounds = true
            selectedImage = image
            self.userImage.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
