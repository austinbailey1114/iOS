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
    
    @IBOutlet weak var todaysCals: UILabel!
    @IBOutlet weak var todaysFat: UILabel!
    @IBOutlet weak var todaysCarbs: UILabel!
    @IBOutlet weak var todaysProtein: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keepContext = TabController.currentContext
        user = TabController.currentUser
        //pull date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        //add up todays nutrient totals
        var Cals: Int = 0
        var Fat: Int = 0
        var Carbs: Int = 0
        var Protein: Int = 0
        
        let mealHistory = user!.value(forKey: "previousMeals")
        for meal in mealHistory as! [String] {
            var details = meal.components(separatedBy: ",")
            if details[5] == result {
                Cals += Int(details[1])!
                Fat += Int(details[2])!
                Carbs += Int(details[3])!
                Protein += Int(details[4])!
            }
            else {
                break
            }
        }
        todaysCals.text! = "Today's calories: " + String(Cals) + "cals"
        todaysFat.text! = "Today's fat: " + String(Fat) + "g"
        todaysCarbs.text! = "Today's carbs: " + String(Carbs) + "g"
        todaysProtein.text! = "Today's protein: " + String(Protein) + "g"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        //pull date
        if nameInput.text! == "" || calsInput.text! == "" || fatInput.text! == "" || carbsInput.text! == "" || proteinInput.text! == "" {
            createAlert(title: "Missing Input", message: "Please enter a value in all fields")
            return
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        //pull users lift history and add the new lift
        let mealHistory = user!.value(forKey: "previousMeals") as? [String]
        let newMeal = nameInput.text! + "," + calsInput.text! + "," + proteinInput.text! + "," + fatInput.text! + "," + carbsInput.text! + "," + result
        let newMealHistory = [newMeal] + mealHistory!
        user!.setValue(newMealHistory, forKey: "previousMeals")
        //save new meal, if it does not already exist
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meals")
        request.returnsObjectsAsFaults = false
        var mealExists = false
        do {
            let results = try keepContext!.fetch(request) as! [NSManagedObject]
            for result in results {
                if result.value(forKey: "name") as! String? == nameInput.text! {
                    mealExists = true
                    break
                }
            }
        }
        catch {
            //add code
        }
        
        if mealExists == false {
            let newMeal = NSEntityDescription.insertNewObject(forEntityName: "Meals", into: keepContext!)
            newMeal.setValue(nameInput.text!, forKey: "name")
            newMeal.setValue(calsInput.text!, forKey: "calories")
            newMeal.setValue(fatInput.text!, forKey: "fat")
            newMeal.setValue(proteinInput.text!, forKey: "protein")
            newMeal.setValue(carbsInput.text!, forKey: "carbs")
            
        }
        
        
        do {
            //the key to actually saving the data
            try keepContext!.save()
        }
        catch {
            
        }
        
        nameInput.text = ""
        calsInput.text = ""
        proteinInput.text = ""
        fatInput.text = ""
        carbsInput.text = ""
        
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
