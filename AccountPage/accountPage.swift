//
//  accountPage.swift
//  socialApp1
//
//  Created by Joe Smith on 11/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper
import FirebaseDatabase
import FirebaseStorage

class accountPage: UIViewController {
    
    var ref: DatabaseReference!
    @IBOutlet weak var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        updateUserInfo()
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.gray.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "uid")
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toSignIn", sender: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    @IBAction func editPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "toEditAccount", sender: nil)
        
    }
    
    func updateUserInfo() {
        let userID = (Auth.auth().currentUser?.uid)
        ref.child("users").child(userID!).child("userData").observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
        let value = snapshot.value as? NSDictionary
        let userImg = value?["userImg"] as? String ?? ""
        let httpsReference = Storage.storage().reference(forURL: userImg)
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
            print("Error getting image")
          } else {
            let image = UIImage(data: data!)
            self.userImage.image = image
          }
        }
        let username = value?["username"] as? String ?? ""
            self.usernameLabel.text = username
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var courseLabel: UILabel!
    
        
        
            
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
