//
//  SavedMealsTableViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/9/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class SearchFoodTableView: UITableViewController {
    
    var keepContext : NSManagedObjectContext?
    var user: NSManagedObject?
    public static var searchText: String?
    var results = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* user = TabController.currentUser
        keepContext = TabController.currentContext*/
        
        results = getResults()
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

    //set number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //set number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    //set cell at each index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFoodTableViewCell", for: indexPath) as? SearchFoodTableViewCell else {
            fatalError("fatal error")
        }
        
        let result = results[indexPath.row]
        let details = result.components(separatedBy: "~")
        
        cell.nameLabel.text! = details[1]
        cell.idLabel.text! = details[0]
        cell.brandLabel.text! = "Brand: " + details[2]
        return cell
    }
    
    //handle user tap on a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        let indexpath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexpath!) as! SearchFoodTableViewCell
        //let url1 = "https://api.nutritionix.com/v1_1/search/"
        //let url2 = "?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=0af8b9cd&appKey=07ed209f3e49ec4e97c57be6e6fdaf00"
        
        let url3 = "https://api.nutritionix.com/v1_1/item?id="
        let url4 = "&appId=82868d5e&appKey=570ad5e7ef23f13c3e952eb71798b586"
        
        //make REST call to Nutritionix API and save the data in the users meal history
        var isFinished: Bool = false
        let urlString = URL(string: url3 + cell.idLabel.text! + url4)
        var newMeal = ""
        let task = URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
            if error != nil {
                print("error")
            }
            else {
                if let content = data {
                    do {
                        let myjson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        newMeal += myjson["item_name"]! as! String
                        newMeal += "`"
                        newMeal += String(myjson["nf_calories"]! as! Int)
                        newMeal += "`"
                        newMeal += String(myjson["nf_protein"]! as! Int)
                        newMeal += "`"
                        newMeal += String(myjson["nf_total_fat"]! as! Int)
                        newMeal += "`"
                        newMeal += String(myjson["nf_total_carbohydrate"]! as! Int)
                        newMeal += "`"
                        newMeal += result
                        isFinished = true
                    }
                    catch {
                        print("error")
                    }
                }
                
            }
        }
        task.resume()
        
        while(!isFinished) {
            
        }

        let mealHistory = user!.value(forKey: "previousMeals") as? [String]
        let newMealHistory = [newMeal] + mealHistory!
        user!.setValue(newMealHistory, forKey: "previousMeals")
        do {
            try keepContext!.save()
        }
        catch {
            
        }
        tableView.deselectRow(at: indexpath!, animated: true)
                
        createAlert(title: "Meal Added", message: "Meal added to your meal history.")
        
        
        return
    }
    
    //create alerts
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //make REST call to nutritionix API and return array of the results, which will be diplayed in each cell
    func getResults() -> [String] {
        
        var isFinished: Bool = false
        
        let url1 = "https://api.nutritionix.com/v1_1/search/"
        let url2 = "?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=592ced70&appKey=4dcb7f7bd109b3975dd3bad0020b6f2a"
        
        let urlString = URL(string: url1 + SearchFoodTableView.searchText! + url2)
        var searchResults = [String]()
        
        let task = URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
            if error != nil {
                print("error")
            }
            else {
                if let content = data {
                    do {
                        let myjson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        let hits = myjson["hits"] as! [NSDictionary]
                        for item in hits {
                            var item_string: String = ""
                            item_string += item["_id"]! as! String
                            let info = item["fields"] as! NSDictionary
                            item_string += "~"
                            item_string += info["item_name"]! as! String
                            item_string += "~"
                            item_string += info["brand_name"]! as! String
                            searchResults.append(item_string)
                        }
                        isFinished = true
                    }
                    catch {
                        print("error")
                    }
                }
                
            }
        }
        task.resume()
        
        while(!isFinished) {
            
        }
        
        return searchResults
        
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