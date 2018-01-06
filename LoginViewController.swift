//
//  LoginViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 11/5/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loginActivity: UIActivityIndicatorView!
    var responseString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        passwordInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        loginActivity.hidesWhenStopped = true
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        loginActivity.startAnimating()
        
        let username = self.usernameInput.text!
        let password = self.passwordInput.text!
        
        DispatchQueue.global().async {
            var notFinished = false
            let url = URL(string: "https://www.austinmbailey.com/projects/liftappsite/api/checkLogin.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let postString = "username=" + username + " &password=" + password
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error")
                    self.titleLabel.text! = "Login failed"
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response")
                    self.titleLabel.text! = "Login failed"
                    return
                }
                
                self.responseString = String(data: data, encoding: .utf8)
                notFinished = true
            }
            task.resume()
            
            while !notFinished {
            }
            
            DispatchQueue.main.sync {
                
                var jsonData = self.responseString!.data(using: .utf8)
                var userInfo = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! [Dictionary<String, Any>]
                
                if userInfo![0]["id"] != nil {
                    TabController.currentUser = userInfo![0]["id"] as! Int32
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context)
                    newUser.setValue(TabController.currentUser, forKey: "id")
                    
                    do {
                        try context.save()
                    } catch {
                        
                    }
                    self.loginActivity.stopAnimating()
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    
                } else {
                    self.loginActivity.stopAnimating()
                }
                
            }
                
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loginActivity.startAnimating()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            if result.count > 0 {
                print("came true")
                TabController.currentUser = result[0].value(forKey: "id") as! Int32
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        } catch {
            //coredata fetch failed
        }
        
            self.loginActivity.stopAnimating()
 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //close keyboard when return is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
