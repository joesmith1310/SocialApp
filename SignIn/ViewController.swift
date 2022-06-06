//
//  ViewController.swift
//  socialApp1
//
//  Created by Joe Smith on 02/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
     
    @IBOutlet weak var errorBox: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.addTarget(self, action: #selector(passwordBeginEditing), for: .touchDown)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KeychainWrapper.standard.removeAllKeys()
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            self.performSegue(withIdentifier: "toFeed", sender: nil)
        }
    }
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }
                if authResult != nil {
                    KeychainWrapper.standard.set((authResult?.user.uid)!, forKey: "uid")
                    strongSelf.performSegue(withIdentifier: "toFeed", sender: nil)
                }
                else {
                    self?.errorBox.text = "We didn't recognise your username or password"
                }
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        performSegue(withIdentifier: "toCreateAccount", sender: self)
        
    }
    
    @objc func passwordBeginEditing(textField: UITextField) {
        passwordField.isSecureTextEntry = true
    }


}


