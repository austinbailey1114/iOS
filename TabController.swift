//
//  TabController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/4/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class TabController: UITabBarController {
    
    public static var username: String?
    public static var password: String?
    public static var currentUser: NSManagedObject?
    public static var currentContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //Searching Core Data for user + password
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        TabController.currentContext = context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        var userExists: Bool = false
        do {
            let results = try context.fetch(request) as! [NSManagedObject]
            for result in results {
                if result.value(forKey: "username") as! String? == ""
                    && result.value(forKey: "password") as! String? == "" {
                    TabController.currentUser = result
                    userExists = true
                }
            }
        }
            
        catch {
            //add code
        }
        
        if !userExists {
            //create a new user in CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let NewUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
            NewUser.setValue("", forKey: "username")
            NewUser.setValue("", forKey: "password")
            NewUser.setValue([String](), forKey: "previousLifts")
            NewUser.setValue([String](), forKey: "previousMeals")
            NewUser.setValue([String](), forKey: "previousWeights")
            NewUser.setValue("deadlift", forKey: "lift1")
            NewUser.setValue(["No Type Selected"], forKey: "allLifts")
            
            do {
                try context.save()
            }
            catch {
                //do stuff
            }
            TabController.currentUser = NewUser
            TabController.currentContext = context
        }
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
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
