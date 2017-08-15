//
//  MoreTabViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/9/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class MoreTabViewController: UIViewController {

    @IBOutlet weak var newWeightInput: UITextField!
    
    @IBOutlet weak var lift1: UITextField!
    @IBOutlet weak var lift2: UITextField!
    @IBOutlet weak var lift3: UITextField!
    
    var user: NSManagedObject?
    var keepContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateWeightButton(_ sender: UIButton) {
        //pull date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        //add new weight to user's previous weights
        user = TabController.currentUser
        keepContext = TabController.currentContext
        let weightHistory = user!.value(forKey: "previousWeights") as? [String]
        let newWeight = newWeightInput.text! + "," + result
        let newWeightHistory = [newWeight] + weightHistory!
        user!.setValue(newWeightHistory, forKey: "previousWeights")
        newWeightInput.resignFirstResponder()
        do {
            try keepContext!.save()
        }
        catch {
            
        }
        newWeightInput.text! = ""
        
    }
    
    @IBAction func updateTracked(_ sender: UIButton) {
        user = TabController.currentUser
        keepContext = TabController.currentContext
        if lift1.text! != "" {
            user!.setValue(lift1.text!, forKey: "lift1")
        }
        if lift2.text! != "" {
            user!.setValue(lift2.text!, forKey: "lift2")
        }
        if lift3.text! != "" {
            user!.setValue(lift3.text!, forKey: "lift3")
        }
        do {
            try keepContext!.save()
        }
        catch {
            
        }
    }
    
        
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //close keyboard when touching outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //close keyboard when return key is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newWeightInput.resignFirstResponder()
        return true
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
