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
    
    //MARK: Properties
    
    @IBOutlet weak var UserName: UITextField!
    public var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    //MARK: Actions
    
    @IBAction func EnterButton(_ sender: UIButton) {
        name = UserName.text!
        TabController.name = name
        //Storing Core Data:
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let NewUser = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        NewUser.setValue(UserName.text, forKey: "name")
        NewUser.setValue(180, forKey: "bodyweight")
        
        do {
            try context.save()
            print("SAVED")
        }
        catch {
            //do stuff
        }
        //to get the data back
        //put this in the other view controllers
        //let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        //request.returnObjectsAsFaults = false
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? NutritionTab {
            destinationViewController.name = UserName.text!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

