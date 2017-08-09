//
//  NutritionTab.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/3/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class NutritionTab: UIViewController {
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var calsInput: UITextField!
    @IBOutlet weak var proteinInput: UITextField!
    @IBOutlet weak var fatInput: UITextField!
    @IBOutlet weak var carbsInput: UITextField!
    var user: NSManagedObject?
    var keepContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keepContext = TabController.currentContext
        user = TabController.currentUser
        //set delegates for keyboard purposes
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        //pull date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        //pull users lift history and add the new lift
        let mealHistory = user!.value(forKey: "previousMeals") as? [String]
        let newMeal = nameInput.text! + "," + calsInput.text! + "," + proteinInput.text! + "," + fatInput.text! + "," + carbsInput.text! + "," + result
        let newMealHistory = [newMeal] + mealHistory!
        user!.setValue(newMealHistory, forKey: "previousMeals")
        nameInput.text = ""
        calsInput.text = ""
        proteinInput.text = ""
        fatInput.text = ""
        carbsInput.text = ""
        do {
            //the key to actually saving the data
            try keepContext!.save()
        }
        catch {
            
        }
        nameInput.resignFirstResponder()
        calsInput.resignFirstResponder()
        proteinInput.resignFirstResponder()
        fatInput.resignFirstResponder()
        carbsInput.resignFirstResponder()
    }
    
    //close keyboard when user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //close keyboard when return is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameInput.resignFirstResponder()
        calsInput.resignFirstResponder()
        proteinInput.resignFirstResponder()
        fatInput.resignFirstResponder()
        carbsInput.resignFirstResponder()
        return true
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
