//
//  inAppNav.swift
//  socialApp1
//
//  Created by Joe Smith on 08/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAuth

class inAppNav: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updatePageIndex(index: 1)

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var leftNavImg: UIImageView!
    
    @IBOutlet weak var midNavImg: UIImageView!
    
    @IBOutlet weak var rightNavImg: UIImageView!
    
    
    
    let userPageVac = UIImage(systemName: "person")
    let userPageOcc = UIImage(systemName: "person.fill")
    let feedPageVac = UIImage(systemName: "rectangle.stack.person.crop")
    let feedPageOcc = UIImage(systemName: "rectangle.stack.person.crop.fill")
    let starPageVac = UIImage(systemName: "star")
    let starPageOcc = UIImage(systemName: "star.fill")
    
    var containerViewController: pageViewController?
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPageView" {
            containerViewController = segue.destination as? pageViewController
        }
    }
    
    func updatePageIndex(index: Int) {
        
     
    
        if index == 0 {
            leftNavImg.image = userPageOcc
            midNavImg.image = feedPageVac
            rightNavImg.image = starPageVac
        }
        if index == 1 {
            leftNavImg.image = userPageVac
            midNavImg.image = feedPageOcc
            rightNavImg.image = starPageVac
        }
        if index == 2 {
            leftNavImg.image = userPageVac
            midNavImg.image = feedPageVac
            rightNavImg.image = starPageOcc
        }
            

        
        
        
    }
    
    @IBAction func accountButtonPressed(_ sender: Any) {
        if let mychild = self.children.first as? pageViewController {
            mychild.setView(index: 0)
            updatePageIndex(index: 0)
        }
    }
    
    @IBAction func feedButtonPressed(_ sender: Any) {
        if let mychild = self.children.first as? pageViewController {
            mychild.setView(index: 1)
            updatePageIndex(index: 1)
        }
    }
    
    @IBAction func matchButtonPressed(_ sender: Any) {
        if let mychild = self.children.first as? pageViewController {
            mychild.setView(index: 2)
            updatePageIndex(index: 2)
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
