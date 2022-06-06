//
//  contactPopup.swift
//  socialApp1
//
//  Created by Joe Smith on 06/05/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class contactPopup: UIViewController {
    
    var ref : DatabaseReference!
    var userID : String!
    var contactHandle : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setBorders()
        copyButton.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getContactInfo()
    }
    
    func setBorders() {
        //popupBackground.layer.borderWidth = 1
        popupBackground.layer.masksToBounds = false
        //popupBackground.layer.borderColor = UIColor.gray.cgColor
        popupBackground.layer.cornerRadius = 15
        popupBackground.clipsToBounds = true
        popupImage.layer.borderWidth = 1
        popupImage.layer.masksToBounds = false
        popupImage.layer.borderColor = UIColor.gray.cgColor
        popupImage.layer.cornerRadius = popupImage.frame.height/2
        popupImage.clipsToBounds = true
        //copyButton.layer.borderWidth = 1
        copyButton.layer.masksToBounds = false
        //popupBackground.layer.borderColor = UIColor.gray.cgColor
        copyButton.layer.cornerRadius = copyButton.frame.height/2
        copyButton.clipsToBounds = true
        closeButton.layer.masksToBounds = false
        closeButton.layer.cornerRadius = closeButton.frame.height/2
        closeButton.clipsToBounds = true
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var popupBackground: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var popupIntro: UILabel!
    @IBOutlet weak var popupImage: UIImageView!
    @IBOutlet weak var contactInfo: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBAction func copyButtonPressed(_ sender: Any) {
        UIPasteboard.general.string = contactHandle
    }
    
    func getContactInfo() {
        ref.child("users").child(userID).child("userData").observeSingleEvent(of: .value, with: { (snapshot) in
            var _contactMethod = ""
              // Get user value
            let value = snapshot.value as? NSDictionary
            if let contactMethod = value?["contactMethod"] as? String {
                _contactMethod = contactMethod
                if contactMethod == "Snapchat" {
                    self.popupImage.image = UIImage(named: "snapchatLogo")
                }
                else if contactMethod == "Instagram" {
                    self.popupImage.image = UIImage(named: "instagramLogo")
                }
                else if contactMethod == "Facebook" {
                    self.popupImage.image = UIImage(named: "facebookLogo")
                }
                else if contactMethod == "Twitter" {
                    self.popupImage.image = UIImage(named: "twitterLogo")
                }
                else if contactMethod == "Phone" {
                    self.popupImage.image = UIImage(named: "phoneLogo2")
                }
                else if contactMethod == "Other" {
                    self.popupImage.image = UIImage(systemName: "questionmark")
                }
            }
            if _contactMethod != "" {
                if let contactInfo = value?["contactInfo"] as? String {
                    self.contactInfo.text = contactInfo
                    self.contactHandle = contactInfo
                    self.copyButton.isHidden = false
                }
                let name = value?["name"] as? String
                if name != "" && name != nil {
                    if _contactMethod == "Other" {
                        self.popupIntro.text = name! + " has provided alternative contact information:"
                    }
                    else {
                        self.popupIntro.text = name! + "'s " + _contactMethod + " is:"
                    }
                }
                else {
                    if _contactMethod == "Other" {
                        self.popupIntro.text = "This user has provided alternative contact information:"
                    }
                    else {
                        self.popupIntro.text = "This users " + _contactMethod + " is:"
                    }
                }
            }
            else {
                let name = value?["name"] as? String
                if name != "" && name != nil {
                    self.popupIntro.text = name! + " has not given any contact information :("
                }
                else {
                    self.popupIntro.text = "This user has not given any contact information :("
                }
                self.popupImage.image =  UIImage(systemName: "questionmark")
                //self.copyButton.imageView?.backgroundColor = UIColor.gray
                self.copyButton.isHidden = true
                self.contactInfo.isHidden = true
            }
        })
    }
}
