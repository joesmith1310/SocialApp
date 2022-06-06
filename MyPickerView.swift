//
//  MyPickerView.swift
//  socialApp1
//
//  Created by Joe Smith on 16/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import Foundation

class MyPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
 
    var pickerData : [String]!
    var pickerTextField : UITextField!
 
    init(pickerData: [String], dropdownField: UITextField) {
        super.init(frame: CGRectZero)
 
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
 
        self.delegate = self
        self.dataSource = self
 
        dispatch_async(dispatch_get_main_queue(), {
            if pickerData.count &gt; 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.enabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.enabled = false
            }
        })
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // Sets number of columns in picker view
    
 
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -&gt; String? {
        return pickerData[row]
    }
 
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
    }
 
 
}
