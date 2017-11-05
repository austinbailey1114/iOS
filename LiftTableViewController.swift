//
//  LiftTableViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/4/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class LiftTableViewController: UITableViewController {

    var user: NSManagedObject?
    var keepContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //user = TabController.currentUser
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //set number of sections in table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //set number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let liftHistory = user!.value(forKey: "previousLifts") as? [String]
        return liftHistory!.count
    }
    
    //set the cell at each index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //remember to change the identifier to the appropriate name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LiftTableViewCell", for: indexPath) as? LiftTableViewCell else {
            fatalError("Fatal error")
        }
        let liftHistory = user!.value(forKey: "previousLifts") as? [String]
        
        let name = liftHistory![indexPath.row]
        let details = name.components(separatedBy: ",")
        //weight,reps,name,date
        let dateComponents = details[3].components(separatedBy: ".")
        cell.displayDateLabel.text = dateComponents[1]+"/"+dateComponents[0]
        cell.UserNameLabel.text = details[2]
        cell.displayWeightLabel.text = "Weight: " + details[0]
        cell.displayRepsLabel.text = "Reps: " + details[1]
        
        return cell
    }
    
    //handle cell deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        /*if editingStyle == .delete {
            print("Delete")
            
            keepContext = TabController.currentContext
            
            var liftHistory = user!.value(forKey: "previousLifts") as? [String]
            liftHistory!.remove(at: indexPath.row)
            user!.setValue(liftHistory!, forKey: "previousLifts")
            
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
