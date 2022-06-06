//
//  otherUserPage.swift
//  socialApp1
//
//  Created by Joe Smith on 22/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class otherUserPage: UIViewController{
    
    @IBOutlet weak var revealButton: UIButton!
    @IBOutlet weak var revealButtonBackground: UIView!
    @IBOutlet weak var revealButtonView: UIImageView!
    @IBAction func revealButtonPressed(_ sender: Any) {
    }
    @IBOutlet weak var pageButton: UIButton!
    var ref : DatabaseReference!
    var thisUserId : String = Auth.auth().currentUser!.uid
    var _userID = ""
    var _requestedUsers = [String]()
    var _recievedUsers = [String]()
    var _friends = [String]()
    var _relationship : Int!
    //0 = requested user
    //1 = request recieved from user
    //2 = friend
    //3 = not met

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        if let mychild = self.children.first as? otherUserTableView {
            mychild.getUserInfo(userID : _userID)
        }
        getFriends { () -> () in
            self.getRecievedUsers { () -> () in
                self.getRequestedUsers { () -> () in
                    self.setupPage(userID: self._userID)
                    self.identifyRelationship()
                    self.setRevealButton()
                }
            }
        }
        makeImageCircle()
        makeViewRounded(view : addFriendView)
        makeViewRounded(view: revealButtonBackground)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? contactPopup {
            destination.userID = _userID
        }
    }
    func makeImageCircle() {
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.gray.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
    }
    func makeViewRounded(view : UIView) {
        view.layer.cornerRadius = view.frame.height/2
        view.layer.borderWidth = 0
    }
    func makeImgViewRounded(view : UIImageView) {
        view.layer.cornerRadius = view.frame.height/2
        view.layer.borderWidth = 0
    }
    
    func getRequestedUsers(completion: @escaping () -> Void) {
        self._requestedUsers.removeAll()
        Database.database().reference().child("users").child(thisUserId).child("sentRequests").observeSingleEvent(of: .value) { (snapshot) in
             guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                 return
             }
             for data in  snapshot {
                 let userID = data.key
                self._requestedUsers.append(userID)
             }
             completion()
         }
    }
    func getRecievedUsers(completion: @escaping () -> Void)  {
         self._recievedUsers.removeAll()
         Database.database().reference().child("users").child(thisUserId).child("recievedRequests").observeSingleEvent(of: .value) { (snapshot) in
             guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                 return
             }
             for data in  snapshot {
                 let userID = data.key
                self._recievedUsers.append(userID)
             }
            completion()
         }
    }
    func getFriends(completion: @escaping () -> Void) {
         self._friends.removeAll()
         Database.database().reference().child("users").child(thisUserId).child("friends").observeSingleEvent(of: .value) { (snapshot) in
             guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
             }
             for data in  snapshot {
                 let userID = data.key
                self._friends.append(userID)
             }
             completion()
         }
    }
    
    func identifyRelationship() {
        if _friends.contains(_userID) {
            _relationship = 2
            pageButton.setTitle("Remove Friend", for: .normal)
        }
        else if _recievedUsers.contains(_userID) {
            _relationship = 1
            pageButton.setTitle("Accept Request", for: .normal)
        }
        else if _requestedUsers.contains(_userID) {
                _relationship = 0
                pageButton.setTitle("Request Sent", for: .normal)
        }
        else {
            _relationship = 3
            pageButton.setTitle("Add Friend", for: .normal)
        }
        print(Int(_relationship))
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var addFriendView: UIView!
    
    @IBAction func addFriendPressed(_ sender: Any) {
        if _relationship == 3 {
            ref.child("users").child(thisUserId).child("sentRequests").updateChildValues([_userID : _userID])
            ref.child("users").child(_userID).child("recievedRequests").updateChildValues([thisUserId : thisUserId])
            pageButton.setTitle("Request Sent", for: .normal)
        }
        else if _relationship == 0 || _relationship == 1 {
            let outbox : DatabaseReference = ref.child("users").child(thisUserId).child("sentRequests").child(_userID)
            outbox.removeValue()
            let inbox : DatabaseReference = ref.child("users").child(thisUserId).child("recievedRequests").child(_userID)
            inbox.removeValue()
            let theirOutbox : DatabaseReference = ref.child("users").child(_userID).child("sentRequests").child(thisUserId)
            theirOutbox.removeValue()
            let theirInbox : DatabaseReference = ref.child("users").child(_userID).child("recievedRequests").child(thisUserId)
            theirInbox.removeValue()
            if _relationship == 1 {
                ref.child("users").child(thisUserId).child("friends").updateChildValues([_userID : _userID])
                ref.child("users").child(_userID).child("friends").updateChildValues([thisUserId : thisUserId])
                pageButton.setTitle("Remove Friend", for: .normal)
            }
            else {
                pageButton.setTitle("Add Friend", for: .normal)
            }
        }
        else if _relationship == 2 {
            let myFriend : DatabaseReference = ref.child("users").child(thisUserId).child("friends").child(_userID)
            myFriend.removeValue()
            let theirFriend : DatabaseReference = ref.child("users").child(_userID).child("friends").child(thisUserId)
            theirFriend.removeValue()
            pageButton.setTitle("Add Friend", for: .normal)
        }
        getFriends { () -> () in
            self.getRecievedUsers { () -> () in
                self.getRequestedUsers { () -> () in
                    self.identifyRelationship()
                    self.setRevealButton()
                }
            }
        }
    }
    
    func setupPage(userID : String) {
        ref.child("users").child(userID).child("userData").observeSingleEvent(of: .value, with: { (snapshot) in
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
            self.username.text = username
          }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func backPressed (_ sender: Any) {
        
        //performSegue(withIdentifier: "toFeed", sender: nil)
        dismiss(animated: true, completion: nil)
        
    }
    func setRevealButton() {
        if _relationship == 2 {
            revealButton.setTitle("Reveal", for: .normal)
            let blueColour = UIColor(red: 99, green: 57, blue: 131)
            revealButtonBackground.backgroundColor = blueColour
            revealButtonView.image = nil
        }
        else {
            revealButton.setTitle("", for: .normal)
            let greyColour = UIColor(red: 225, green: 225, blue: 225)
            revealButtonBackground.backgroundColor = greyColour
            revealButtonView.image = UIImage(systemName: "lock")
        }
    }
    
    
    @IBAction func revealPressed(_ sender: Any) {
        if _relationship == 2 {
            performSegue(withIdentifier: "toContactPopup", sender: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
