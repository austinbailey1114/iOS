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
    var responseString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        passwordInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
    }
    
    @IBAction func login(_ sender: UIButton) {
        var notFinished = false
        let url = URL(string: "https://www.austinmbailey.com/projects/liftappsite/api/checkLogin.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let username = usernameInput.text!
        let password = passwordInput.text!
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
        
        if let userInfo = self.convertToDictionary(text: self.responseString!) {
            TabController.currentUser = userInfo["id"] as! Int32
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context)
            newUser.setValue(TabController.currentUser, forKey: "id")
            
            do {
                try context.save()
            } catch {
                
            }
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        else {
            self.titleLabel.text! = "Login Failed"
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            if result.count > 0 {
                print("came true")
                TabController.currentUser = result[0].value(forKey: "id") as! Int32
                performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        } catch {
            //coredata fetch failed
        }
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
