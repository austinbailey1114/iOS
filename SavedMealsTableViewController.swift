//
//  SavedMealsTableViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/9/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class SavedMealsTableViewController: UITableViewController {
    
    var keepContext : NSManagedObjectContext?
    var results: [NSManagedObject]?
    var user: NSManagedObject?
    //let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = TabController.currentUser
        keepContext = TabController.currentContext
        
        //searchController.searchResultsUpdater = self
        //searchController.dimsBackgroundDuringPresentation = false
        //definesPresentationContext = true
        //tableView.tableHeaderView = searchController.searchBar
        
        
        
        let url1 = "https://api.nutritionix.com/v1_1/search/"
        let url2 = "?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=82868d5e&appKey=570ad5e7ef23f13c3e952eb71798b586"
        
        //let url3 = "https://api.nutritionix.com/v1_1/item?id="
        //let url4 = "&appId=82868d5e&appKey=570ad5e7ef23f13c3e952eb71798b586"
        
        let urlString = URL(string: url1 + "oikos" + url2)
        let task = URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
            if error != nil {
                print("error")
            }
            else {
                if let content = data {
                    do {
                        let myjson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        print(myjson)
                        let hits = myjson["hits"] as! [NSDictionary]
                        for item in hits {
                            print(item["_id"]!)
                            let info = item["fields"] as! NSDictionary
                            print(info["item_name"]!)
                        }
                        /*let keys = myjson.allKeys
                        let values = myjson.allValues as! [NSDictionary]
                        for item in values {
                            print(item["item_name"]!)
                        }*/
                    }
                    catch {
                        print("error")
                    }
                }
                
            }
        }
        task.resume()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meals")
        request.returnsObjectsAsFaults = false
        do {
            results = try keepContext!.fetch(request) as? [NSManagedObject]
        }
        catch {
            
        }
        tableView.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (results?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("made it here")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMealTableViewCell", for: indexPath) as? SavedMealTableViewCell else {
            fatalError("fatal error")
        }
        let result = results![indexPath.row]
        
        cell.nameLabel.text! = result.value(forKey: "name") as! String
        cell.calsLabel.text! = result.value(forKey: "calories") as! String
        cell.fatLabel.text! = result.value(forKey: "fat") as! String
        cell.carbsLabel.text! = result.value(forKey: "carbs") as! String
        cell.proteinLabel.text! = result.value(forKey: "protein") as! String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        let indexpath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexpath!) as! SavedMealTableViewCell
        let newMeal = cell.nameLabel.text! + "," + cell.calsLabel.text! + "," + cell.fatLabel.text! + "," + cell.carbsLabel.text! + "," + cell.proteinLabel.text! + "," + result
        let mealHistory = user!.value(forKey: "previousMeals") as? [String]
        let newMealHistory = [newMeal] + mealHistory!
        user!.setValue(newMealHistory, forKey: "previousMeals")
        do {
            try keepContext!.save()
        }
        catch {
            
        }
        tableView.deselectRow(at: indexpath!, animated: true)
        return
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
