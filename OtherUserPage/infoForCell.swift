//
//  infoForCell.swift
//  socialApp1
//
//  Created by Joe Smith on 24/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import Foundation

class infoForCell {
    
    private var _label : String
    private var _labelText : String
    private var _largeText : Bool
    
    var label : String {
        return _label
    }
    
    var labelText : String {
        return _labelText
    }
    var largeText : Bool {
        return _largeText
    }
    
    init(label : String, labelText : String, largeText : Bool) {
        _label = label
        _labelText = labelText
        _largeText = largeText
    }
}
