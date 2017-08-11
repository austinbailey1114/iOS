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
        let templiftHistory = user!.value(forKey: "previousLifts") as? [String]
        let liftHistory = templiftHistory!.reversed()
        for lift in liftHistory {
            var details = lift.components(separatedBy: ",")
            yvalues.append(calculateMax(weight: details[0], reps: details[1]))
            xvalues.append(details[3] + "," + details[2])
        }
        setChart(dataPoints: xvalues, values: yvalues)
        
    }
    func setChart(dataPoints: [String], values: [Double]) {
        //create data entries for each lift
        var deadChartEntry = [ChartDataEntry]()
        var squatChartEntry = [ChartDataEntry]()
        var benchChartEntry = [ChartDataEntry]()
        //add data each lift into the correct line
        var j: Double = 0
        var h: Double = 0
        var k: Double = 0
        for i in 0..<dataPoints.count {
            let details = dataPoints[i].components(separatedBy: ",")
            if details[1].lowercased() == "deadlift" {
                let value = ChartDataEntry(x: j, y: values[i])
                deadChartEntry.append(value)
                j = j + 1
            }
            else if details[1].lowercased() == "squat" {
                let value = ChartDataEntry(x: h, y: values[i])
                squatChartEntry.append(value)
                h = h + 1
            }
            else if details[1].lowercased() == "bench" {
                let value = ChartDataEntry(x: k, y: values[i])
                benchChartEntry.append(value)
                k = k + 1
            }
        }
        //add data to the graph
        let deadline = LineChartDataSet(values: deadChartEntry, label: "Deadlift")
        deadline.setColor(UIColor(red:0.00, green:0.73, blue:0.50, alpha:1.0))
        deadline.setCircleColor(UIColor(red:0.00, green:0.73, blue:0.50, alpha:1.0))
        deadline.circleHoleRadius = 0
        deadline.circleRadius = 5
        let squatline = LineChartDataSet(values: squatChartEntry, label: "Squat")
        squatline.setColor(UIColor(red:0.00, green:0.53, blue:0.69, alpha:1.0))
        squatline.setCircleColor(UIColor(red:0.00, green:0.53, blue:0.69, alpha:1.0))
        squatline.circleHoleRadius = 0
        squatline.circleRadius = 5
        let benchline = LineChartDataSet(values: benchChartEntry, label: "Bench")
        benchline.setColor(UIColor(red:0.87, green:0.08, blue:0.09, alpha:1.0))
        benchline.setCircleColor(UIColor(red:0.87, green:0.08, blue:0.09, alpha:1.0))
        benchline.circleHoleRadius = 0
        benchline.circleRadius = 5
        let data = LineChartData()
        data.addDataSet(deadline)
        data.addDataSet(squatline)
        data.addDataSet(benchline)
        liftChartView.drawGridBackgroundEnabled = false
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
