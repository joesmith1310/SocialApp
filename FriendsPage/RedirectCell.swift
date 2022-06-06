//
//  RedirectCell.swift
//  socialApp1
//
//  Created by Joe Smith on 28/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit

class RedirectCell: UITableViewCell {
    
    @IBOutlet weak var label : UILabel!
    var delegate : segueDelegate!
    
    @IBAction func userButton(_ sender: Any) {
        if(self.delegate != nil){ //Just to be safe.
            if label.text == "Sent Requests" {
                self.delegate.callSegueFromCell(redirectID: 5)
            }
            else if label.text == "Recieved Requests" {
                self.delegate.callSegueFromCell(redirectID: 6)
            }
        }
            
        else {
            print("ERROR")
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configCell (label : String) {
        self.label.text = label
    }

}
