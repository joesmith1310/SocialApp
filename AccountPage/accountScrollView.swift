//
//  accountScrollView.swift
//  socialApp1
//
//  Created by Joe Smith on 16/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class accountScrollView: UIViewController {
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUserInfo()
    }
    
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactInfo: UILabel!
    @IBOutlet weak var contactMethod: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var accomLabel: UILabel!
    
    func updateUserInfo() {
    
        let userID = (Auth.auth().currentUser?.uid)
        ref.child("users").child(userID!).child("userData").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let course = value?["course"] {
                self.courseLabel.text = course as? String
            }
            if let _contactMethod = value?["contactMethod"] {
                self.contactMethod.text = _contactMethod as? String
            }
            if let _contactInfo = value?["contactInfo"] {
                self.contactInfo.text = _contactInfo as? String
            }
            if let name = value?["name"] {
                self.nameLabel.text = name as? String
            }
            if let accom = value?["accom"] {
                self.accomLabel.text = accom as? String
            }
            if let about = value?["about"] {
                self.aboutLabel.text = about as? String
            }
            if let from = value?["from"] {
                self.fromLabel.text = from as? String
            }
            if let year = value?["year"] {
                self.yearLabel.text = year as? String
            }
        }) { (error) in
            print(error.localizedDescription)
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
