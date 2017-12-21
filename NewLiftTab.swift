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

    @IBOutlet weak var liftHistoryButton: UIButton!
    @IBOutlet weak var liftProgressButton: UIButton!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    @IBOutlet weak var dateInput: UITextField!
    @IBOutlet weak var saveActivity: UIActivityIndicatorView!
    var username: String?
    var user: Int32?
    
    var allLifts = [String]()
    var liftType = ""
    var noLifts = ["No Lifts Available"]
    
    var responseString: String?
    
    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //set liftPicker as inputview to typeInput
        let liftPicker = UIPickerView()
        liftPicker.dataSource = self
        liftPicker.delegate = self
        typeInput.inputView = liftPicker
        
        typeInput.text! = "No Type Selected"
        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.timeZone = NSTimeZone.local
        dateInput.inputView = datePicker
        
        //set accessoryview to UIToolBar
        
        let toolBar = UIToolbar()
        let addNewButton = UIBarButtonItem(title: "Add New", style: .done, target: self, action: #selector(NewLiftTab.addNew))
        addNewButton.tintColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
        toolBar.setItems([addNewButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        typeInput.inputAccessoryView = toolBar
        
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        // Apply date format
        dateInput.isUserInteractionEnabled = true
        
        //set delegates for keyboard purposes
        self.weightInput.delegate = self
        self.repsInput.delegate = self
        self.typeInput.delegate = self
        self.dateInput.delegate = self
        
        self.navigationItem.leftItemsSupplementBackButton = true
        
        //get data for picker wheel
        user = TabController.currentUser
        var notFinished = false
        let url = URL(string: "https://austinmbailey.com/projects/liftappsite/api/lifttypes.php?id=" + String(user!))!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            self.responseString = String(data: data, encoding: .utf8)
            notFinished = true
        }
        task.resume()
        
        while !notFinished {
            
        }
        
        let jsonData = responseString!.data(using: .utf8)
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! [Dictionary<String, Any>]
        
        for item in dictionary! {
            allLifts.append(item["name"] as! String)
        }
        
        //UI setup
        weightInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        repsInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        typeInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        //liftPicker.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        dateInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        
        //add done button to keyboards
        weightInput.returnKeyType = UIReturnKeyType.done
        typeInput.returnKeyType = UIReturnKeyType.done
        repsInput.returnKeyType = UIReturnKeyType.done
        dateInput.returnKeyType = UIReturnKeyType.done
        
        for lift in allLifts {
            print(lift)
        }
        
        saveActivity.hidesWhenStopped = true
    }
    
    @IBAction func saveLiftButton(_ sender: UIButton) {
        saveActivity.startAnimating()
        
        DispatchQueue.global().async() {
            
            
            // Do heavy work here
            
            if self.weightInput.text!.doubleValue == nil || self.repsInput.text!.doubleValue == nil {
                self.createAlert(title: "Invalid Input", message: "Please make sure that weight and reps boxes contain numbers, and type is not blank.")
                return
            }
            let weight = self.weightInput.text!
            let reps = self.repsInput.text!
            let type = self.typeInput.text!.replacingOccurrences(of: "_", with: " ")
            
            var notFinished = false
            let url = URL(string: "https://www.austinmbailey.com/projects/liftappsite/api/insertLift.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let postString = "id=" + String(self.user!) + "&weight=" + weight + "&reps=" + reps + "&type=" + type.replacingOccurrences(of: " ", with: "_") + "&date="
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response")
                }
                
                self.responseString = String(data: data, encoding: .utf8)
                print(self.responseString!)
                notFinished = true
            }
            
            task.resume()
            
            while !notFinished {
                
            }
            
            DispatchQueue.main.sync {
                 self.saveActivity.stopAnimating()
                 self.weightInput.resignFirstResponder()
                 self.repsInput.resignFirstResponder()
                 self.typeInput.resignFirstResponder()
                 self.dateInput.resignFirstResponder()
                 self.weightInput.text! = ""
                 self.repsInput.text! = ""
                 self.dateInput.text = ""
            }
            
        }
        
    }
    
    //returns index where a lift should be inserted in liftHistory
    func binInsert(newDate: String, liftHistory: [String], start: Int, end: Int) -> Int {
        let mid = (start + end) / 2
        let components = liftHistory[mid].components(separatedBy: ",")
        if components[3] == newDate || end <= start{
            return mid
        }
        else if compareDates(oldDate: components[3], newDate: newDate) == -1{
            return binInsert(newDate: newDate, liftHistory: liftHistory, start: mid+1, end: end)
        }
        else {
            return binInsert(newDate: newDate, liftHistory: liftHistory, start: start, end: mid)
        }
    }
    
    //close keyboard when user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //close keyboard when return is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //calculate one rep max of a lift
    func calculateMax (weight: Double, reps: Double) -> Int32 {
        return Int32(weight*(1+(reps/30)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //create alerts
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //set pickerview size
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //make items in each picker view slot
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allLifts[row].replacingOccurrences(of: "_", with: " ")
    }
    
    //set pickerView size
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allLifts.count
    }
    
    //handle user interaction with picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if allLifts.count > 0 {
            liftType = allLifts[row]
            typeInput.text! = allLifts[row].replacingOccurrences(of: "_", with: " ")
        }
    }
    
    //reload view any time it is opened
    override func viewWillAppear(_ animated: Bool) {
    }
    
    //handle date picker value changes
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        dateInput.text! = selectedDate
    }
    
    //compare dates for insertion purposes
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
    
    @objc func addNew() {
        performSegue(withIdentifier: "addNewType", sender: nil)
    }
    

}
