//
//  MealTableViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/4/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class MealTableViewController: UITableViewController {
    
    var user: NSManagedObject?
    var keepContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //user = TabController.currentUser
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //set number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //set number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mealHistory = user!.value(forKey: "previousMeals") as? [String]
        return mealHistory!.count
    }

    //set cell at each index in table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell else {
            fatalError("Fatal error")
        }
        let mealHistory = user!.value(forKey: "previousMeals") as? [String]
        
        let name = mealHistory![indexPath.row]
        let details = name.components(separatedBy: "`")
        //name,cals,fat,protein,carbs,date
        cell.mealLabel.text = details[0]
        cell.caloriesLabel.text = details[1] + " calories"
        cell.fatLabel.text = "Fat: " + details[3] + "g"
        cell.proteinLabel.text = "Protein: " + details[2] + "g"
        cell.carbsLabel.text = "Carbs: " + details[4] + "g"
        let dateComponents = details[5].components(separatedBy: ".")
        cell.dateLabel.text = dateComponents[1]+"/"+dateComponents[0]
        
        return cell
    }
    
    //handle cell deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        /*if editingStyle == .delete {
            print("Delete")
            
            keepContext = TabController.currentContext
            
            var mealHistory = user!.value(forKey: "previousMeals") as? [String]
            mealHistory!.remove(at: indexPath.row)
            user!.setValue(mealHistory!, forKey: "previousMeals")
            
            do {
                try keepContext!.save()
            }
            catch {
                
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }*/
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
