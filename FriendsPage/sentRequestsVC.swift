//
//  sentRequestsVC.swift
//  socialApp1
//
//  Created by Joe Smith on 28/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit

class sentRequestsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    
    func refresh () {
        if let mychild = self.children.first as? sentRequests {
            mychild.getUsers()
            mychild.tableView.reloadData()
        }
        else {
            print("ERROR DURING REFRESH")
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        
        //performSegue(withIdentifier: "toFeed", sender: nil)
        dismiss(animated: true, completion: nil)
        
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
