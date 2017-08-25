//
//  NewLiftTab.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/3/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class NewLiftTab: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    var username: String?
    var user: NSManagedObject?
    var keepContext: NSManagedObjectContext?
    
    var allLifts = [String]()
    var liftType = ""
    var noLifts = ["No Lifts Available"]
    
    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var liftPicker: UIPickerView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var background1: UIView!
    @IBOutlet weak var background2: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeInput.isHidden = true
        typeLabel.isHidden = true
        //load in the current user's data
        keepContext = TabController.currentContext
        user = TabController.currentUser
        //set delegates for keyboard purposes
        self.weightInput.delegate = self
        self.repsInput.delegate = self
        self.typeInput.delegate = self
        
        self.navigationItem.leftItemsSupplementBackButton = true
        
        //get data for picker wheel
        allLifts = (user!.value(forKey: "allLifts") as? [String])!
        allLifts[1] = "Add New"
        user!.setValue(allLifts, forKey: "allLifts")

    }
    
    @IBAction func saveLiftButton(_ sender: UIButton) {
        //print(liftType!)
        print("break0")
        if weightInput.text!.doubleValue == nil || repsInput.text!.doubleValue == nil {
            createAlert(title: "Invalid Input", message: "Please make sure that weight and reps boxes contain numbers, and type is not blank.")
            return
        }
        //pull date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        //pull users lift history and add the new lift
        let liftHistory = user!.value(forKey: "previousLifts") as? [String]
        if typeInput.text! != "" {
            liftType = typeInput.text!
        }
        if liftType == "No Type Selected" {
            createAlert(title: "Please Enter a Lift Type", message: "Please enter a lift type with either the picker wheel or the text box.")
            return
        }
        let newLift = weightInput.text! + "," + repsInput.text! + "," + liftType + "," + result
        let newLiftHistory = [newLift] + liftHistory!
        user!.setValue(newLiftHistory, forKey: "previousLifts")
        //add lift to allLifts if it does not exist in it
        print("break3")
        var allLifts = user!.value(forKey: "allLifts") as? [String]
        if !(allLifts!.contains(typeInput.text!))  && typeInput.text! != "" {
            allLifts! = allLifts! + [typeInput.text!]
            user!.setValue(allLifts!, forKey: "allLifts")
        }
        //close keyboard
        weightInput.resignFirstResponder()
        repsInput.resignFirstResponder()
        typeInput.resignFirstResponder()

        //reset text boxes
        weightInput.text! = ""
        repsInput.text! = ""
        typeInput.text! = ""
        do {
            //the key to actually saving the data
            try keepContext!.save()
        }
        catch {
            
        }
        
        liftPicker.reloadAllComponents()
        
    }
    //close keyboard when user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //close keyboard when return is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weightInput.resignFirstResponder()
        repsInput.resignFirstResponder()
        typeInput.resignFirstResponder()
        return true
    }
    
    func calculateMax (weight: Double, reps: Double) -> Int32 {
        return Int32(weight*(1+(reps/30)))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if allLifts.count > 0 {
            return allLifts[row]
        }
        return noLifts[row]
    }*/
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        allLifts = (user!.value(forKey: "allLifts") as? [String])!
        let titleData = allLifts[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        allLifts = (user!.value(forKey: "allLifts") as? [String])!
        if allLifts.count > 0 {
            return allLifts.count
        }
        return noLifts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        allLifts = (user!.value(forKey: "allLifts") as? [String])!
        if allLifts.count > 0 {
            liftType = allLifts[row]
        }
        if allLifts[row] == "Add New" {
            typeInput.isHidden = false
            typeLabel.isHidden = false
        }
        else {
            typeLabel.isHidden = true
            typeInput.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        liftPicker.reloadAllComponents()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
