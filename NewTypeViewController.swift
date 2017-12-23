//
//  NewTypeViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 10/15/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class NewTypeViewController: UIViewController {
    
    @IBOutlet weak var newTypeInput: UITextField!
    @IBOutlet weak var saveActivity: UIActivityIndicatorView!
    
    var user: Int32?
    var responseString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTypeInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        saveActivity.hidesWhenStopped = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addType(_ sender: UIButton) {
        
        user = TabController.currentUser
        saveActivity.startAnimating()
        
        let name = self.newTypeInput.text!
        
        DispatchQueue.global().async() {
            
            
            // Do heavy work here
            
            if name == "" {
                self.createAlert(title: "Invalid Input", message: "Please make sure that weight and reps boxes contain numbers, and type is not blank.")
                return
            }
            
            var notFinished = false
            let url = URL(string: "https://www.austinmbailey.com/projects/liftappsite/api/insertLifttype.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let postString = "id=" + String(self.user!) + "&name=" + name.replacingOccurrences(of: " ", with: "_")
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response")
                }
                
                self.responseString = String(data: data, encoding: .utf8)
                print(self.responseString!)
                notFinished = true
            }
            
            task.resume()
            
            while !notFinished {
                
            }
            
            DispatchQueue.main.sync {
                self.saveActivity.stopAnimating()
                self.newTypeInput.text! = ""
                self.newTypeInput.resignFirstResponder()
                
            }
            
        }
        
    }
    
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
