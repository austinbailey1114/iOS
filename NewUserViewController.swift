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
    
    @IBOutlet weak var nameWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        
        nameInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        usernameInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        passwordInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        emailInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        
        let screenSize: CGRect = UIScreen.main.bounds
        nameWidthConstraint.constant = screenSize.width * 0.90
        usernameWidthConstraint.constant = screenSize.width * 0.90
        passwordWidthConstraint.constant = screenSize.width * 0.90
        emailWidthConstraint.constant = screenSize.width * 0.90

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
                
                self.performSegue(withIdentifier: "backToLogin", sender: nil)
                
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //close keyboard when return is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
