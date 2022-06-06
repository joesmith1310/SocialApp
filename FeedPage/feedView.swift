//
//  feedView.swift
//  socialApp1
//
//  Created by Joe Smith on 05/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class feedView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()

        // Do any additional setup after loading the view.
    }
    
    
    func refresh () {
        if let mychild = self.children.first as? feedVC {
            mychild.getUsers()
        }
        else {
            print("ERROR DURING REFRESH")
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
