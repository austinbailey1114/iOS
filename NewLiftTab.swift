//
//  NewLiftTab.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/3/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData
class NewLiftTab: UIViewController {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var displaySquat: UILabel!
    @IBOutlet weak var displayDeadlift: UILabel!
    @IBOutlet weak var displayBench: UILabel!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load in the current user's data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        var user: NSManagedObject
        do {
            let results = try context.fetch(request) as! [NSManagedObject]
            for result in results {
                if result.value(forKey: "username") as! String? == TabController.username!
                && result.value(forKey: "password") as! String? == TabController.password! {
                    displaySquat.text = result.value(forKey: "squat") as? String
                    displayDeadlift.text = result.value(forKey: "deadlift") as? String
                    displayBench.text = result.value(forKey: "bench") as? String
                    user = result
                }
            }
        }
        catch {
           //do stuff
        }


    }
    @IBAction func saveLiftButton(_ sender: UIButton) {
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
