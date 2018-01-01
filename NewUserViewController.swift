//
//  NewUserViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 1/1/18.
//  Copyright © 2018 Austin Bailey. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    
    var responseString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addUser(_ sender: Any) {
        
        let name = nameInput.text!
        let username = usernameInput.text!
        let password = passwordInput.text!
        let email = emailInput.text!
        
        DispatchQueue.global().async() {
            
            if name == "" || username == "" || password == "" || email == "" {
                self.createAlert(title: "Invalid Input", message: "Please make sure that weight and reps boxes contain numbers, and type is not blank.")
                return
            }
            
            var notFinished = false
            let url = URL(string: "https://www.austinmbailey.com/projects/liftappsite/api/insertUser.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let postString = "name=" + name + "&username=" + username + "&password=" + password + "&email=" + email
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
                
            }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
