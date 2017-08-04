//
//  ViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/3/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //Properties
    
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var noLogin: UILabel!
    
    public var name: String = ""
    public var pass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        var userExists: Bool = false
        do {
            let results = try context.fetch(request) as! [NSManagedObject]
            for result in results {
                if result.value(forKey: "username") as! String? == UserName.text!
                && result.value(forKey: "password") as! String? == Password.text! {
                    userExists = true
                }
            }
        }
            
        catch {
            //add code
        }
        
        if userExists == false {
            noLogin.text = "Incorrect login!"
        }
        else {
            if(userExists == true) {
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
        //Storing new users core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let NewUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        NewUser.setValue(UserName.text, forKey: "username")
        NewUser.setValue(Password.text, forKey: "password")
        
        do {
            try context.save()
        }
        catch {
            //do stuff
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

