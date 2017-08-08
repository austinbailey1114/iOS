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
                    user = result
                    break
                }
            }
        }
        catch {
            //do stuff
        }

        
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
