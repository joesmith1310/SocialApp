//
//  feedVC.swift
//  socialApp1
//
//  Created by Joe Smith on 19/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

protocol MyCustomCellDelegator {
    func callSegueFromCell(userID : String)
}

class feedVC: UITableViewController, MyCustomCellDelegator {
    
    func callSegueFromCell(userID : String) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "id4") as! otherUserPage
        secondViewController._userID = userID
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? userCellTableViewCell else {
            print("ERROR2")
            return UITableViewCell()
        }
        cell.configCell(user: users[indexPath.row])
        cell.delegate = self
        

        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height;
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOtherUserPage" {
            if let destination = segue.destination as? otherUserPage {
                destination.setupPage(userID:  )
            }
        }
    }*/
    
    func getUsers() {
        var _thisCode = ""
        if let userID = (Auth.auth().currentUser?.uid) {
            Database.database().reference().child("users").child(userID).child("userData").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let userCode = value?["userCode"] {
                    _thisCode = userCode as! String
                }
            }) { (error) in
                       print(error.localizedDescription)
               }
            Database.database().reference().child("users").observeSingleEvent(of: .value) { (snapshot) in
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                    return
                }
                self.users.removeAll()
                for data in  snapshot {
                    var _username = ""
                    var _userImg = ""
                    var _userBio = ""
                    var _userCode = ""
                    let _userID = data.key
                    var _userMatch = 0
                    let userData = data.childSnapshot(forPath: "userData")
                    guard let userDict = userData.value as? NSDictionary else {
                        return
                    }
                    if let username = userDict["username"] {
                        _username = username as! String
                    }
                    if let userImg = userDict["userImg"] {
                        _userImg = userImg as! String
                    }
                    if let userBio = userDict["about"] {
                        _userBio = userBio as! String
                    }
                    if let userCode = userDict["userCode"] {
                        _userCode = userCode as! String
                    }
                    let comparator = codeComparator(userCode : _thisCode, compareWith: _userCode)
                    _userMatch = comparator.match
                    let user = User(username: _username, userImg: _userImg, userBio: _userBio, userMatch: _userMatch, userID: _userID)
                    self.users.append(user)
                
                }
                self.tableView.reloadData()
            }
        }
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
