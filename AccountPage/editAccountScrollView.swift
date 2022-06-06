//
//  editAccountScrollView.swift
//  socialApp1
//
//  Created by Joe Smith on 16/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class editAccountScrollView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let coursePickerView = UIPickerView()
    let contactPickerView = UIPickerView()
    let yearPickerView = UIPickerView()
    let accomodationPickerView = UIPickerView()
    let regionPickerView = UIPickerView()
    //Add here when adding category
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == coursePickerView {
            return courseList.count
        }
        else if pickerView == yearPickerView {
            return yearList.count
        }
        else if pickerView == accomodationPickerView {
            return accomodations.count
        }
        else if pickerView == regionPickerView {
            return regions.count
        }
        else if pickerView == contactPickerView {
            return contactMethods.count
        }
        //Add here when adding category
        else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == coursePickerView {
            return courseList[row]
        }
        else if pickerView == yearPickerView {
            return yearList[row]
        }
        else if pickerView == accomodationPickerView {
            return accomodations[row]
        }
        else if pickerView == regionPickerView {
            return regions[row]
        }
        else if pickerView == contactPickerView {
            return contactMethods[row]
        }
        //Add here when adding category
        else {
            return "None"
        }
    
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == coursePickerView {
            selectedCourse = courseList[row]
            courseTextField.text = selectedCourse
        }
        else if pickerView == yearPickerView {
            selectedYear = yearList[row]
            yearTextField.text = selectedYear
        }
        else if pickerView == accomodationPickerView {
            selectedAccomodation = accomodations[row]
            accomTextField.text = selectedAccomodation
        }
        else if pickerView == regionPickerView {
            selectedRegion = regions[row]
            fromTextField.text = selectedRegion
        }
        else if pickerView == contactPickerView {
            selectedContactMethod = contactMethods[row]
            if selectedContactMethod != "" {
                self.contactInfoField.isUserInteractionEnabled = true
            }
            else {
                self.contactInfoField.isUserInteractionEnabled = false
            }
            contactMethodField.text = selectedContactMethod
        }
        //Add here when adding category
    }
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        initialiseEditAccount()
        createCoursePickerView()
        createYearPickerView()
        createAccomodationPickerView()
        createRegionPickerView()
        createContactPickerView()
        //Add here when adding category
        dismissPickerView()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: UITextField) {
           sender.resignFirstResponder()
       }
    
    func initialiseEditAccount() {
        let userID = (Auth.auth().currentUser?.uid)
        ref.child("users").child(userID!).child("userData").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let course = value?["course"] {
                self.courseTextField.text = course as? String
            }
            if let name = value?["name"] {
                self.nameTextField.text = name as? String
            }
            if let contactMethod = value?["contactMethod"] {
                self.contactMethodField.text = contactMethod as? String
                if contactMethod as? String == "" {
                    self.contactInfoField.isUserInteractionEnabled = false
                }
            }
            else {
                self.contactInfoField.isUserInteractionEnabled = false
            }
            if let contactInfo = value?["contactInfo"] {
                self.contactInfoField.text = contactInfo as? String
            }
            if let accom = value?["accom"] {
                self.accomTextField.text = accom as? String
            }
            if let about = value?["about"] {
                self.aboutTextField.text = about as? String
            }
            if let from = value?["from"] {
                self.fromTextField.text = from as? String
            }
            if let year = value?["year"] {
                self.yearTextField.text = year as? String
            }
            //Add here when adding category
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateUserInfo() {
        
        let userID = (Auth.auth().currentUser?.uid)!
        if let course = courseTextField.text {
            selectedCourse = course
            ref.child("users").child(userID).child("userData").updateChildValues(["course": course])
        }
        if let name = nameTextField.text {
            ref.child("users").child(userID).child("userData").updateChildValues(["name": name])
        }
        if let contactMethod = contactMethodField.text {
                   ref.child("users").child(userID).child("userData").updateChildValues(["contactMethod": contactMethod])
        }
        if let contactInfo = contactInfoField.text {
            ref.child("users").child(userID).child("userData").updateChildValues(["contactInfo": contactInfo])
        }
        if let accom = accomTextField.text {
            selectedAccomodation = accom
            ref.child("users").child(userID).child("userData").updateChildValues(["accom": accom])
        }
        if let year = yearTextField.text {
            selectedYear = year
            ref.child("users").child(userID).child("userData").updateChildValues(["year": year])
        }
        if let about = aboutTextField.text {
            ref.child("users").child(userID).child("userData").updateChildValues(["about": about])
        }
        if let from = fromTextField.text {
            selectedRegion = from
            ref.child("users").child(userID).child("userData").updateChildValues(["from": from])
        }
        //Add here when adding category
        let userCode = updateUserCode()
        ref.child("users").child(userID).child("userData").updateChildValues(["userCode": userCode])
        
    }
    
    @IBOutlet weak var contactInfoField: UITextField!
    @IBOutlet weak var contactMethodField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var accomTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextView!
    @IBOutlet weak var fromTextField: UITextField!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var selectedCourse: String?
    var courseList = ["(CAL) Birmingham Law School", "(CAL) Centre for Byzantine, Ottoman and Modern Greek Studies", "(CAL) College of Arts and Law", "(CAL) Department of African Studies and Anthropology", "(CAL) Department of American and Canadian Studies", "(CAL) Department of Art History, Curating and Visual Studies", "(CAL) Department of Classics, Ancient History and Archaeology", "(CAL) Department of Drama and Theatre Arts", "(CAL) Department of English Language and Linguistics", "(CAL) Department of English Literature", "(CAL) Department of Film and Creative Writing", "(CAL) Department of History", "(CAL) Department of Modern Languages", "(CAL) Department of Music", "(CAL) Department of Philosophy", "(CAL) Department of Theology and Religion", "(CAL) Ironbridge International Institute for Cultural Heritage", "(CAL) Shakespeare Institute", "(EPS) Department of Civil Engineering", "(EPS) Department of Electronic, Electrical and Systems Engineering", "(EPS) Department of Mechanical Engineering", "(EPS) Engineering and Physical Sciences", "(EPS) School of Chemical Engineering", "(EPS) School of Chemistry", "(EPS) School of Computer Science", "(EPS) School of Engineering", "(EPS) School of Mathematics", "(EPS) School of Metallurgy and Materials", "(EPS) School of Physics and Astronomy", "(LES) Life and Environmental Sciences", "(LES) School of Biosciences", "(LES) School of Geography, Earth and Environmental Sciences", "(LES) School of Psychology", "(LES) School of Sport, Exercise and Rehabilitation Sciences", "(MDS) Birmingham Medical School", "(MDS) Graduate School", "(MDS) Institute of Applied Health Research", "(MDS) Institute of Cancer and Genomic Sciences", "(MDS) Institute of Cardiovascular Sciences", "(MDS) Institute of Clinical Sciences", "(MDS) Institute of Immunology and Immunotherapy", "(MDS) Institute of Inflammation and Ageing", "(MDS) Medcal and Dental Sciences", "(MDS) Medical Education", "(MDS) School of Biomedical Sciences", "(MDS) School of Dentistry", "(MDS) School of Nursing", "(MDS) School of Pharmacy", "(SSc) Business School", "(SSc) Centre for Public Sector Partnerships", "(SSc) Centre for Russian, European and Eurasion Studies", "(SSc) Centre for Urban and Regional Studies", "(SSc) Department of International Development", "(SSc) Department of Management", "(SSc) Department of Marketing", "(SSc) Department of Political Science and International Studies", "(SSc) Department of Social Policy, Sociology and Criminology", "(SSc) Department of Social Work and Social Care", "(SSc) Department of Sociology", "(SSc) Health Services Management", "(SSc) Institute of Local Government Studies", "(SSc) School of Education", "(SSc) School of Government", "(SSc) Social Sciences", "(SSc) The Department of Accounting", "(SSc) The Department of Economics", "(SSc) The Department of Finance"]
    
    var selectedYear: String?
    var yearList = ["First", "Second", "Third", "Fourth", "Fifth"]
    
    var selectedAccomodation: String?
    var accomodations = ["(UOB) Aitken","(UOB) Ashcroft","(UOB) Bournbrook","(UOB) Chamberlain","(UOB) Green Community","(UOB) Elgar Court", "(UOB) Jarrat Hall","(UOB) Maplebank","(UOB) Mason","(UOB) Oakley Court","(UOB) Shackleton","(UOB) Tennis Courts", "(UOB) The Global Community", "(UOB) The Spinney", "(PA) Battery Park", "(PA) Liberty Court", "(PA) Liberty Park", "(PA) Selly Oak Court", "(PA) The Metalworks","House in Selly Oak", "Other Accomodation", "Live at Home"]
    
    var selectedRegion : String?
    var regions = ["Greater Lodon", "South East", "South West", "West Midlands", "North West", "North East", "Yorkshire and the Humber", "East Midlands", "East Anglia", "Scotland", "Wales", "European Country", "North America", "South America", "Asia", "Australia", "Africa"]
    
    var selectedContactMethod : String?
    var contactMethods = ["", "Snapchat", "Instagram", "Facebook", "Twitter", "Phone", "Other"]
    //Add here when adding category
    
    func createCoursePickerView() {
       coursePickerView.delegate = self
       courseTextField.inputView = coursePickerView
    }
    func createYearPickerView() {
       yearPickerView.delegate = self
       yearTextField.inputView = yearPickerView
    }
    func createAccomodationPickerView() {
        accomodationPickerView.delegate = self
        accomTextField.inputView = accomodationPickerView
    }
    func createRegionPickerView() {
        regionPickerView.delegate = self
        fromTextField.inputView = regionPickerView
    }
    func createContactPickerView() {
        contactPickerView.delegate = self
        contactMethodField.inputView = contactPickerView
    }
    
    //Add here when adding category
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       courseTextField.inputAccessoryView = toolBar
       yearTextField.inputAccessoryView = toolBar
       accomTextField.inputAccessoryView = toolBar
       fromTextField.inputAccessoryView = toolBar
       contactMethodField.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    func updateUserCode() -> String {
        var userCode = ""
        if let courseIndex = courseList.firstIndex(of: selectedCourse!) {
            if courseIndex <= 18 {
                userCode.append("00.")
            }
            else if courseIndex <= 29{
                userCode.append("80.")
            }
            else if courseIndex <= 34{
                userCode.append("40.")
            }
            else if courseIndex <= 48{
                userCode.append("60.")
            }
            else if courseIndex <= courseList.count{
                userCode.append("20.")
            }
            else {
                userCode.append("xx.")
            }
        }
        else {
            userCode.append("xx.")
            print("Selected course not in list.")
        }
        
        //
        if selectedYear == yearList[0] {
            userCode.append("00.")
        }
        else if selectedYear == yearList[1] {
            userCode.append("20.")
        }
        else if selectedYear == yearList[2] {
            userCode.append("40.")
        }
        else if selectedYear == yearList[3] {
            userCode.append("60.")
        }
        else if selectedYear == yearList[4] {
            userCode.append("80.")
        }
        else {
            userCode.append("xx.")
        }
        //
        if selectedAccomodation == accomodations[0] {
            userCode.append("75.")
        }
        else if selectedAccomodation == accomodations[1] {
            userCode.append("50.")
        }
        else if selectedAccomodation == accomodations[2] {
            userCode.append("00.")
        }
        else if selectedAccomodation == accomodations[3] {
            userCode.append("76.")
        }
        else if selectedAccomodation == accomodations[4] {
            userCode.append("77.")
        }
        else if selectedAccomodation == accomodations[5] {
            userCode.append("78.")
        }
        else if selectedAccomodation == accomodations[6] {
            userCode.append("01.")
        }
        else if selectedAccomodation == accomodations[7] {
            userCode.append("79.")
        }
        else if selectedAccomodation == accomodations[8] {
            userCode.append("80.")
        }
        else if selectedAccomodation == accomodations[9] {
            userCode.append("51.")
        }
        else if selectedAccomodation == accomodations[10] {
            userCode.append("81.")
        }
        else if selectedAccomodation == accomodations[11] {
            userCode.append("82.")
        }
        else if selectedAccomodation == accomodations[12] {
            userCode.append("52.")
        }
        else if selectedAccomodation == accomodations[13] {
            userCode.append("53.")
        }
        else if selectedAccomodation == accomodations[14] {
            userCode.append("02.")
        }
        else if selectedAccomodation == accomodations[15] {
            userCode.append("95.")
        }
        else if selectedAccomodation == accomodations[16] {
            userCode.append("03.")
        }
        else if selectedAccomodation == accomodations[17] {
            userCode.append("04.")
        }
        else if selectedAccomodation == accomodations[18] {
            userCode.append("05.")
        }
        else if selectedAccomodation == accomodations[19] {
            userCode.append("06.")
        }
        else if selectedAccomodation == accomodations[20] {
            userCode.append("xx.")
        }
        else if selectedAccomodation == accomodations[21] {
            userCode.append("xx.")
        }
        else {
            userCode.append("xx.")
        }
        //
        if selectedRegion == regions[9] {
            userCode.append("00.")
        }
        else if selectedRegion == regions[4] {
            userCode.append("12.")
        }
        else if selectedRegion == regions[5] {
            userCode.append("16.")
        }
        else if selectedRegion == regions[6] {
            userCode.append("20.")
        }
        else if selectedRegion == regions[3] {
            userCode.append("27.")
        }
        else if selectedRegion == regions[7] {
            userCode.append("30.")
        }
        else if selectedRegion == regions[8] {
            userCode.append("38.")
        }
        else if selectedRegion == regions[1] {
            userCode.append("40.")
        }
        else if selectedRegion == regions[0] {
            userCode.append("43.")
        }
        else if selectedRegion == regions[2] {
            userCode.append("55.")
        }
        else if selectedRegion == regions[10] {
            userCode.append("23.")
        }
        else if selectedRegion == regions[11] {
            userCode.append("73.")
        }
        else if selectedRegion == regions[12] {
            userCode.append("65.")
        }
        else if selectedRegion == regions[13] {
            userCode.append("77.")
        }
        else if selectedRegion == regions[14] {
            userCode.append("95.")
        }
        else if selectedRegion == regions[15] {
            userCode.append("67.")
        }
        else if selectedRegion == regions[16] {
            userCode.append("85.")
        }
        else {
            userCode.append("xx.")
            print("error")
        }
        //Add here when adding category
        return userCode
        
        
    }

}

