//
//  NutritionTab.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/3/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class NutritionTab: UIViewController, UITextFieldDelegate {
    
    var user: Int32?
    var responseString: String?
    
    @IBOutlet weak var searchDatabase: UITextField!
    @IBOutlet weak var todaysCals: UILabel!
    @IBOutlet weak var todaysFat: UILabel!
    @IBOutlet weak var todaysCarbs: UILabel!
    @IBOutlet weak var todaysProtein: UILabel!
        
    @IBOutlet weak var nutritionView: UIView!
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchDatabase.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        todaysProtein.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        
        loadActivity.hidesWhenStopped = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadActivity.startAnimating()
        
        var calories = 0
        var fat = 0
        var carb = 0
        var protein = 0
        
        DispatchQueue.global().async {
            
            //GET data for graphs
            self.user = TabController.currentUser
            //hit URL for lifts
            var notFinished = false
            let url = URL(string: "https://austinmbailey.com/projects/liftappsite/api/food.php?id=" + String(self.user!))!
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
                
                for item in dictionary! {
                    calories += item["calories"]as! Int
                    fat += item["fat"] as! Int
                    carb += item["carbs"] as! Int
                    protein += item["protein"] as! Int
                }
                
                self.todaysCals.text! = "Today's calories: " + String(calories)
                self.todaysFat.text! = "Today's fat: " + String(fat) + "g"
                self.todaysCarbs.text! = "Today's carbs: " + String(carb) + " g"
                self.todaysProtein.text! = "Today's protein: " + String(protein) + "g"
                
                self.loadActivity.stopAnimating()
            }
        }
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
    
    //remove spaces for using database
    @IBAction func searchDatabaseButton(_ sender: UIButton) {
        SearchFoodTableView.searchText = searchDatabase.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    //create alerts
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
