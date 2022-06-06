//
//  otherUserPageCellTableViewCell.swift
//  socialApp1
//
//  Created by Joe Smith on 22/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit

class otherUserPageCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(info : infoForCell) {
        _infoLabel.text = info.label
        _info.text = info.labelText
    }
    
    @IBOutlet weak var _infoLabel: UILabel!
    @IBOutlet weak var _info: UILabel!

}
