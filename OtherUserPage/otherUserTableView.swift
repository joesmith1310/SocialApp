//
//  otherUserTableView.swift
//  
//
//  Created by Joe Smith on 24/04/2020.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class otherUserTableView: UITableViewController {
    
    var infoFields = [infoForCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoFields.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if infoFields[indexPath.row].largeText == true {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "otherUserInfoFieldLarge") as? otherUserPageCellLarge else {
                    return UITableViewCell()
                }
                cell.configCell(info: infoFields[indexPath.row])
                return cell
            }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "otherUserInfoField") as? otherUserPageCellTableViewCell else {
                return UITableViewCell()
            }
            cell.configCell(info : infoFields[indexPath.row])
            return cell
            }
    }
    
    
    func getUserInfo(userID : String) {
        print("YES")
        infoFields.removeAll()
        Database.database().reference().child("users").child(userID).child("userData").observeSingleEvent(of: .value) { (snapshot) in
        
        let value = snapshot.value as? NSDictionary
        
            if let _name = value?["name"] as? String {
                if _name != "" {
                    let name = infoForCell(label: "Name:", labelText: _name, largeText: false)
                    self.infoFields.append(name)
                }
            }
            if let _about = value?["about"] as? String {
                if _about != "" {
                    let about = infoForCell(label: "About:", labelText: _about, largeText: true)
                    self.infoFields.append(about)
                }
            }
            if let _from = value?["from"] as? String {
                if _from != "" {
                    let from = infoForCell(label: "From:", labelText: _from, largeText: false)
                    self.infoFields.append(from)
                }
            }
            if let _course = value?["course"] as? String {
                if _course != "" {
                    let course = infoForCell(label: "School:", labelText: _course, largeText: false)
                    self.infoFields.append(course)
                }
            }
            if let _accom = value?["accom"] as? String {
                if _accom != "" {
                    let accom = infoForCell(label: "Accomodation:", labelText: _accom, largeText: false)
                    self.infoFields.append(accom)
                }
            }
            if let _year = value?["year"] as? String {
                self.addSmallInfo(info: _year, infoLabel: "Year:")
            }
            
            
        
        self.tableView.reloadData()
        }
            
    }
    
    func addSmallInfo(info : String, infoLabel : String) {
        if info != "" {
            let cell = infoForCell(label: infoLabel, labelText: info, largeText: false)
            self.infoFields.append(cell)
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
