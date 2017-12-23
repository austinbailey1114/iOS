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

    var user: Int32?
    var liftHistory: [Dictionary<String, Any>]?
    var responseString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        var notFinished = false
        
        DispatchQueue.global().async {
            //GET data for graphs
            self.user = TabController.currentUser
            //hit URL for lifts
            let url = URL(string: "https://austinmbailey.com/projects/liftappsite/api/lift.php?id=" + String(self.user!))!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                }
                
                self.responseString = String(data: data, encoding: .utf8)
                notFinished = true
            }
            task.resume()
            
            while !notFinished {
                
            }
            
            DispatchQueue.main.sync {
                //build dictionary of lift data
                let jsonData = self.responseString!.data(using: .utf8)
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! [Dictionary<String, Any>]
                self.liftHistory = dictionary
                
                //reload data when process is done
                self.tableView.reloadData()
                
            }
        }
        
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
        //check if liftHistory is loaded in yet. Return 0 if not to avoid crash
        if liftHistory != nil {
            return liftHistory!.count
        }
        return 0
    }
    
    //set the cell at each index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //remember to change the identifier to the appropriate name
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LiftTableViewCell", for: indexPath) as? LiftTableViewCell else {
            fatalError("Fatal error")
        }
        let data = liftHistory![indexPath.row]
        cell.displayDateLabel.text = data["date"] as? String
        let name = data["type"] as? String
        cell.UserNameLabel.text = name?.replacingOccurrences(of: "_", with: " ")
        cell.displayWeightLabel.text = "Weight: " + String(describing: data["weight"]!)
        cell.displayRepsLabel.text = "Reps: " + String(describing: data["reps"]!)
        
        return cell
    }
    
    //handle cell deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = liftHistory![indexPath.row]["id"] as! Int32
            let url = URL(string: "https://austinmbailey.com/projects/liftappsite/api/deleteLift.php?id=" + String(id))!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                }
                
                self.responseString = String(data: data, encoding: .utf8)
            }
            task.resume()
            
            liftHistory!.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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
