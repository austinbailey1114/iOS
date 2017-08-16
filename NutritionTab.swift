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
    
    var user: NSManagedObject?
    var keepContext: NSManagedObjectContext?
    
    @IBOutlet weak var searchDatabase: UITextField!
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
            var details = meal.components(separatedBy: "`")
            if details[5] == result {
                Cals += Int(details[1])!
                Protein += Int(details[2])!
                Fat += Int(details[3])!
                Carbs += Int(details[4])!
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
    
       //close keyboard when user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //close keyboard when return is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchDatabase.resignFirstResponder()
        return true
    }
    @IBAction func searchDatabaseButton(_ sender: UIButton) {
        SavedMealsTableViewController.searchText = searchDatabase.text!.replacingOccurrences(of: " ", with: "_")
    }
    
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    public static func reloadView() {
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
