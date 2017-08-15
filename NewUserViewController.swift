//
//  NewUserViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/6/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class NewUserViewController: UIViewController {

    @IBOutlet weak var bodyWeightInput: UITextField!
    @IBOutlet weak var heightInput: UITextField!
    
    var username: String?
    var pass: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func CreateAccountButton(_ sender: UIButton) {
        //pull date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        //create a new user in CoreData
        username = TabController.username
        pass = TabController.password
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let NewUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        NewUser.setValue(username!, forKey: "username")
        NewUser.setValue(pass!, forKey: "password")
        NewUser.setValue("0", forKey: "squat")
        NewUser.setValue("0", forKey: "deadlift")
        NewUser.setValue("0", forKey: "bench")
        NewUser.setValue([String](), forKey: "previousLifts")
        NewUser.setValue([String](), forKey: "previousMeals")
        NewUser.setValue([bodyWeightInput.text! + "," + result], forKey: "previousWeights")
        NewUser.setValue(bodyWeightInput.text!, forKey: "bodyWeight")
        NewUser.setValue(heightInput.text!, forKey: "height")
        NewUser.setValue("deadlift", forKey: "lift1")
        NewUser.setValue("squat", forKey: "lift2")
        NewUser.setValue("bench", forKey: "lift3")
        
        do {
            try context.save()
        }
        catch {
            //do stuff
        }
        TabController.currentUser = NewUser
        TabController.currentContext = context
        

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
