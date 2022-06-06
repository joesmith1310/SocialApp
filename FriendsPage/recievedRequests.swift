//
//  recievedRequests.swift
//  socialApp1
//
//  Created by Joe Smith on 28/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class recievedRequests: UITableViewController, MyCustomCellDelegator {
    
    func callSegueFromCell(userID : String) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "id4") as! otherUserPage
        secondViewController._userID = userID
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers { () -> () in
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as? FriendCell else {
            print("REQUESTS SENT TABLE VIEW ERROR")
            return UITableViewCell()
        }
        cell.configCell(user: users[indexPath.row])
        cell.delegate = self

        return cell
    }
    
    func getUsers(finished: @escaping () -> Void) {
        if let userID = (Auth.auth().currentUser?.uid) {
            Database.database().reference().child("users").child(userID).child("recievedRequests").observeSingleEvent(of: .value) { (snapshot) in
                self.users.removeAll()
                self.getUserDetails(snapshot: snapshot, completion: { () -> () in
                    finished()
                })
            }
        }
    }
    func getUserDetails(snapshot : DataSnapshot, completion: @escaping () -> Void) {
        guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
            return
        }
        let size = snapshot.count
        self.users.removeAll()
        for data in  snapshot {
            let _userID = data.key
            getUserInfo(userID: _userID, completed: { () -> () in
                if self.users.count == size {
                    completion()
                }
            })
        }
    }
    
    func getUserInfo(userID : String, completed: @escaping () -> Void) {
        Database.database().reference().child("users").child(userID).child("userData").observeSingleEvent(of: .value, with: { (snapshot) in
            var _username = ""
            var _userImg = ""
            //let _userCode = "" //Not used
            let _userBio = "" //Not used
            let _userMatch = 0 //Not used
            let value = snapshot.value as? NSDictionary
            if let username = value?["username"] {
                _username = username as! String
                print(_username)
            }
            if let userImg = value?["userImg"] {
                _userImg = userImg as! String
            }
            let user = User(username: _username, userImg: _userImg, userBio: _userBio, userMatch: _userMatch, userID: userID)
            self.users.append(user)
            completed()
        })
    }
}
