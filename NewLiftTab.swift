//
//  NewLiftTab.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/3/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class NewLiftTab: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var displaySquat: UILabel!
    @IBOutlet weak var displayDeadlift: UILabel!
    @IBOutlet weak var displayBench: UILabel!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    var username: String?
    var user: NSManagedObject?
    var keepContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        //load in the current user's data
        keepContext = TabController.currentContext
        user = TabController.currentUser
        displaySquat.text = user!.value(forKey: "squat") as? String
        displayDeadlift.text = user!.value(forKey: "deadlift") as? String
        displayBench.text = user!.value(forKey: "bench") as? String
        //set delegates for keyboard purposes
        self.weightInput.delegate = self
        self.repsInput.delegate = self
        self.typeInput.delegate = self

    }
    
    @IBAction func saveLiftButton(_ sender: UIButton) {
        //pull date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        //pull users lift history and add the new lift
        let liftHistory = user!.value(forKey: "previousLifts") as? [String]
        let newLift = weightInput.text! + "," + repsInput.text! + "," + typeInput.text! + "," + result
        let newLiftHistory = [newLift] + liftHistory!
        user!.setValue(newLiftHistory, forKey: "previousLifts")
        //set new display of 1RM
        let max = String(calculateMax(weight: Double(weightInput.text!)!, reps: Double(repsInput.text!)!))
        if (typeInput.text!.lowercased() == "bench") {
            user!.setValue(max, forKey: "bench")
            displayBench.text = user!.value(forKey: "bench") as? String
        }
        else if (typeInput.text!.lowercased() == "squat") {
            user!.setValue(max, forKey: "squat")
            displaySquat.text = user!.value(forKey: "squat") as? String
        }
        else if (typeInput.text!.lowercased() == "deadlift") {
            user!.setValue(max, forKey: "deadlift")
            displayDeadlift.text = user!.value(forKey: "deadlift") as? String
        }

        //save 1RM calculation of input
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
        weightInput.resignFirstResponder()
        repsInput.resignFirstResponder()
        typeInput.resignFirstResponder()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
