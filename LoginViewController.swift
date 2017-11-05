//
//  LoginViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 11/5/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    var responseString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: UIButton) {
        var notFinished = false
        let url = URL(string: "http://www.austinmbailey.com/projects/liftappsite/api/checkLogin.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let username = usernameInput.text!
        let password = passwordInput.text!
        let postString = "username=" + username + " &password=" + password
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
            notFinished = true
        }
        task.resume()
        
        while !notFinished {
            
        }
        
        print(responseString!)

        let userInfo = self.convertToDictionary(text: self.responseString!)!
        TabController.currentUser = userInfo["id"] as! Int32
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
