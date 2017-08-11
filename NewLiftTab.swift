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
        //close keyboard
        weightInput.resignFirstResponder()
        repsInput.resignFirstResponder()
        typeInput.resignFirstResponder()

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
        else {
            let title = "Untracked Lift Type"
            let message = "Because the lift " + typeInput.text! + " is not a tracked type, it will not be tracked in the Progress Tab graphs. It will still appear in your previous lifts."
            createAlert(title: title, message: message)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
