//
//  FriendCell.swift
//  socialApp1
//
//  Created by Joe Smith on 28/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseStorage
import FirebaseDatabase

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var userImg : UIImageView!
    @IBOutlet weak var username : UILabel!
    //@IBOutlet weak var userMatch : UILabel!
    
    var delegate : MyCustomCellDelegator!
    @IBOutlet weak var myButton : UIButton!
    
    @IBAction func userButton(_ sender: Any) {
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.callSegueFromCell(userID : userID)
        }
        else {
            print("ERROR")
        }
    }
    
    var user : User!
    var userID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configCell (user : User) {
        self.user = user
        self.username.text = user.username
        self.userID = user.userID
        let ref = Storage.storage().reference(forURL: user.userImg)
        ref.getData(maxSize: 100000000, completion: { (data,error) in
            if error != nil {
                print("could not load image")
            }
            else {
                if let imageData = data {
                    if let img = UIImage(data : imageData) {
                        self.userImg.image = img
                    }
                }
            }
        })
    }
}
