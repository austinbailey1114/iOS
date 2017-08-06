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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        keepContext = context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request) as! [NSManagedObject]
            for result in results {
                if result.value(forKey: "username") as! String? == TabController.username!
                && result.value(forKey: "password") as! String? == TabController.password! {
                    displaySquat.text = result.value(forKey: "squat") as? String
                    displayDeadlift.text = result.value(forKey: "deadlift") as? String
                    displayBench.text = result.value(forKey: "bench") as? String
                    user = result
                    break
                }
            }
        }
        catch {
           //do stuff
        }
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
