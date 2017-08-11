//
//  ViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/3/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Properties
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var noLogin: UILabel!
    
    public var name: String = ""
    public var pass: String = ""
    
    var user: NSManagedObject?
    var thisContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //set delegates for keyboard purposes
        self.UserName.delegate = self
        self.Password.delegate = self
        
    }
    //Actions
    
    @IBAction func EnterButton(_ sender: UIButton) {
        //Passing data to TabController to be used in tabs
        name = UserName.text!
        pass = Password.text!
        TabController.username = name
        TabController.password = pass
        //Searching Core Data for user + password
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        thisContext = context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        var userExists: Bool = false
        do {
            let results = try context.fetch(request) as! [NSManagedObject]
            for result in results {
                if result.value(forKey: "username") as! String? == UserName.text!
                && result.value(forKey: "password") as! String? == Password.text! {
                    user = result
                    userExists = true
                }
            }
        }
            
        catch {
            //add code
        }
        //login only if the user exists
        if userExists == false {
            createAlert(title: "User Does Not Exist", message: "This username and password combination does not exist")
        }
        else {
            if(userExists == true) {
                TabController.currentUser = user
                TabController.currentContext = thisContext
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            }
        }
    }
    
    @IBAction func SignUpButton(_ sender: UIButton) {
        //Creating a new user in Core Data
        name = UserName.text!
        pass = Password.text!
        TabController.username = name
        TabController.password = pass
        }
    //close keyboard when touching outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //close keyboard when return key is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UserName.resignFirstResponder()
        Password.resignFirstResponder()
        return true
    }
    
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

