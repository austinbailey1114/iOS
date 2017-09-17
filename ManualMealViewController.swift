//
//  ManualMealViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/16/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class ManualMealViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var calsInput: UITextField!
    @IBOutlet weak var fatInput: UITextField!
    @IBOutlet weak var carbsInput: UITextField!
    @IBOutlet weak var proteinInput: UITextField!
    
    var user: NSManagedObject?
    var keepContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        proteinInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        nameInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        calsInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        fatInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        carbsInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        
        self.calsInput.delegate = self
        self.nameInput.delegate = self
        self.carbsInput.delegate = self
        self.fatInput.delegate = self
        self.proteinInput.delegate = self
        
        calsInput.returnKeyType = UIReturnKeyType.done
        nameInput.returnKeyType = UIReturnKeyType.done
        carbsInput.returnKeyType = UIReturnKeyType.done
        fatInput.returnKeyType = UIReturnKeyType.done
        proteinInput.returnKeyType = UIReturnKeyType.done

    }

    @IBAction func saveMeal(_ sender: UIButton) {
        if calsInput.text!.doubleValue == nil || fatInput.text!.doubleValue == nil || carbsInput.text!.doubleValue == nil || proteinInput.text!.doubleValue == nil || nameInput.text! == "" {
            createAlert(title: "Invalid Input", message: "Please ensure that no field is blank, and that each field that requires a number contains a number.")
            return
        }
        user = TabController.currentUser
        keepContext = TabController.currentContext
        //pull date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        //add to meal history
        let mealHistory = user!.value(forKey: "previousMeals") as! [String]
        let newMeal = nameInput.text! + "`" + calsInput.text! + "`" + fatInput.text! + "`" + carbsInput.text! + "`" + proteinInput.text! + "`" + result
        let newMealHistory = [newMeal] + mealHistory
        user!.setValue(newMealHistory, forKey: "previousMeals")
        do {
            try keepContext!.save()
        }
        catch {
            
        }
        
        calsInput.text! = ""
        nameInput.text! = ""
        carbsInput.text! = ""
        fatInput.text! = ""
        proteinInput.text! = ""
        
        carbsInput.resignFirstResponder()
        nameInput.resignFirstResponder()
        calsInput.resignFirstResponder()
        fatInput.resignFirstResponder()
        proteinInput.resignFirstResponder()
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //close keyboard when user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
