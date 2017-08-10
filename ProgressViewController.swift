//
//  ProgressViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/10/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ProgressViewController: UIViewController {
    
    var user: NSManagedObject?

    @IBOutlet weak var liftChartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var xvalues = [String]()
        var yvalues = [Double]()
        user = TabController.currentUser
        let liftHistory = user!.value(forKey: "previousLifts") as? [String]
        for lift in liftHistory! {
            var details = lift.components(separatedBy: ",")
            yvalues.append(calculateMax(weight: details[0], reps: details[1]))
            xvalues.append(details[3])
        }
        setChart(dataPoints: xvalues, values: yvalues)
        
    }
    func setChart(dataPoints: [String], values: [Double]) {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<dataPoints.count {
            let value = ChartDataEntry(x: Double(i), y: values[i])
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "TestLifts")
        let data = LineChartData()
        data.addDataSet(line1)
        liftChartView.data = data
        
        
    }

    func calculateMax(weight: String, reps: String) -> Double {
        let weight = Double(weight)
        let reps = Double(reps)
        return (weight!*(1+(reps!/30)))
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
