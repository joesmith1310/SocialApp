//
//  friendsTableViewController.swift
//  socialApp1
//
//  Created by Joe Smith on 28/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol segueDelegate {
    func callSegueFromCell(redirectID : Int)
}

class friendsTableViewController: UITableViewController, segueDelegate, MyCustomCellDelegator {
    
    func callSegueFromCell(userID: String) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "id4") as! otherUserPage
        secondViewController._userID = userID
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    func callSegueFromCell(redirectID : Int) {
        if redirectID == 5 {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "id5") as! sentRequestsVC
            self.present(secondViewController, animated: true, completion: nil)
        }
        else if redirectID == 6 {
            let thirdViewController = self.storyboard?.instantiateViewController(withIdentifier: "id6") as! recievedRequestsVC
            self.present(thirdViewController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUsers {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (users.count + 2)
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "redirectCell") as? RedirectCell else {
                print("SENT RQUESTS CELL ERROR")
                return UITableViewCell()
            }
            cell.configCell(label : "Sent Requests")
            cell.delegate = self
            return cell
        }
        else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "redirectCell") as? RedirectCell else {
                print("RECIEVED REQUESTS CELL ERROR")
                return UITableViewCell()
            }
            cell.configCell(label : "Recieved Requests")
            cell.delegate = self
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as? FriendCell else {
                    print("ERROR LOADING FRIENDS")
                    return UITableViewCell()
            }
            cell.configCell(user: users[indexPath.row - 2])
            cell.delegate = self
            return cell
            }
    }
    
    var users = [User]()
    
    func getUsers(finished: @escaping () -> Void) {
        if let userID = (Auth.auth().currentUser?.uid) {
            Database.database().reference().child("users").child(userID).child("friends").observeSingleEvent(of: .value) { (snapshot) in
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
        users.removeAll()
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
            }
            if let userImg = value?["userImg"] {
                _userImg = userImg as! String
            }
            let user = User(username: _username, userImg: _userImg, userBio: _userBio, userMatch: _userMatch, userID: userID)
            self.users.append(user)
            completed()
        })
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
