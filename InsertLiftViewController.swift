//
//  InsertLiftViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 9/10/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class InsertLiftViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    @IBOutlet weak var dateInput: UITextField!
    @IBOutlet weak var liftPicker: UIPickerView!
    
    var user: NSManagedObject?
    var keepContext: NSManagedObjectContext?
    
    var allLifts = [String]()
    var liftType = ""
    var noLifts = ["No Lifts Available"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = TabController.currentUser
        keepContext = TabController.currentContext
        
        weightInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        repsInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        dateInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        typeInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveLift(_ sender: UIButton) {
        var liftHistory = user!.value(forKey: "previousLifts") as! [String]
        let newLift = weightInput.text! +  "," + repsInput.text! +  "," + typeInput.text! + "," + dateInput.text!
        var i = 0
        var inserted = false
        for lift in liftHistory {
            let components = lift.components(separatedBy: ",")
            if compareDates(oldDate: components[3], newDate: dateInput.text!) == 0 {
                liftHistory.insert(newLift, at: i)
                inserted = true
                break
            }
            else if compareDates(oldDate: components[3], newDate: dateInput.text!) == 1 {
                liftHistory.insert(newLift, at: i)
                inserted = true
                break
            }
            i += 1
        }
        
        if !inserted {
            liftHistory.append(newLift)
        }
        
        user!.setValue(liftHistory, forKey: "previousLifts")
        
        do {
            try keepContext!.save()
        }
        catch {
            
        }
        

    }
    

    func compareDates(oldDate: String, newDate: String) -> Int {
        //returns -1 for new date is earlier date, 0 for same date, 1 for later date
        let oldDateComponents = oldDate.components(separatedBy: ".")
        let newDateComponents = newDate.components(separatedBy: ".")
        if oldDateComponents[2].integerValue! < newDateComponents[2].integerValue! {
            return 1
        }
        else if oldDateComponents[2].integerValue! > newDateComponents[2].integerValue! {
            return -1
        }
        if oldDateComponents[1].integerValue! < newDateComponents[1].integerValue! {
            return 1
        }
        else if newDateComponents[1].integerValue! < oldDateComponents[1].integerValue! {
            return -1
        }
        else {
            if oldDateComponents[0].integerValue! < newDateComponents[0].integerValue! {
                return 1
            }
            else if newDateComponents[0].integerValue! < oldDateComponents[0].integerValue! {
                return -1
            }
            else { return 0 }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        allLifts = (user!.value(forKey: "allLifts") as? [String])!
        let titleData = allLifts[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.black])
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
            typeInput.text! = allLifts[row]
        }
        if allLifts[row] == "Add New" {
            typeInput.text! = ""
            typeInput.becomeFirstResponder()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        liftPicker.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
