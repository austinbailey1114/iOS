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
    var user: Int32?
    var responseString: String?
    public static var searchText: String?
    var results: [Dictionary<String, Any>]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = TabController.currentUser!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {        
        
        var notFinished = false
        
        DispatchQueue.global().async {
            //GET data for graphs
            self.user = TabController.currentUser!
            //hit URL for lifts
            let url = URL(string: "https://austinmbailey.com/projects/liftappsite/api/searchFood.php?search=" + SearchFoodTableView.searchText!)!
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
                self.results = dictionary
                
                //reload data when process is done
                self.tableView.reloadData()
                
            }
        }
        
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
        if results != nil {
            return results!.count
        }
        return 0
    }

    //set cell at each index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFoodTableViewCell", for: indexPath) as? SearchFoodTableViewCell else {
            fatalError("fatal error")
        }
        
        let result = results![indexPath.row]
        
        cell.nameLabel.text! = result["name"] as! String
        cell.idLabel.text! = String(describing: result["id"])
        return cell
    }
    
    //handle user tap on a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var notFinished = false
        
        let id = results![indexPath.row]["id"]
        let user_id = user!
        
        print(id!)
        
        DispatchQueue.global().async {
            //GET data for graphs
            self.user = TabController.currentUser!
            //hit URL for lifts
            let url = URL(string: "https://austinmbailey.com/projects/liftappsite/api/addFoodToHistory.php?id=" + String(describing: id!) + "&user_id=" + String(describing: user_id))!
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
                print(self.responseString!)
                notFinished = true
            }
            task.resume()
            
            while !notFinished {
                
            }
            
            DispatchQueue.main.sync {
               self.createAlert(title: "Food Added Successfully", message: "Added food successfully")
                
            }
        }
        
    }
    
    //create alerts
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
