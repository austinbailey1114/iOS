//
//  NewTypeViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 10/15/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData

class NewTypeViewController: UIViewController {
    
    @IBOutlet weak var newTypeInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        newTypeInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addType(_ sender: UIButton) {
        
        
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
