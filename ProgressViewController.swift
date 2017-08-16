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
    
    @IBOutlet weak var weightChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Build lifting graph
        var xvalues = [String]()
        var yvalues = [Double]()
        user = TabController.currentUser
        let templiftHistory = user!.value(forKey: "previousLifts") as? [String]
        let liftHistory = templiftHistory!.reversed()
        for lift in liftHistory {
            var details = lift.components(separatedBy: ",")
            yvalues.append(calculateMax(weight: details[0], reps: details[1]))
            let dateData = details[3].components(separatedBy: ".")
            xvalues.append(dateData[1] + "/" + dateData[0] + "," + details[2])
        }
        setChart(dataPoints: xvalues, values: yvalues)
        
        //build bodyweight graph
        var dates = [String]()
        var bodyweight = [Double]()
        let tempweightHistory = user!.value(forKey: "previousWeights") as? [String]
        let weightHistory = tempweightHistory!.reversed()
        for weight in weightHistory {
            var details = weight.components(separatedBy: ",")
            bodyweight.append(Double(details[0])!)
            let dateData = details[1].components(separatedBy: ".")
            let date = dateData[1] + "/" + dateData[0]
            dates.append(date)
        }
        setWeightChart(dataPoints: dates, values: bodyweight)
        
        self.navigationItem.hidesBackButton = true

        createAlert(title: "Change Tracked Lifts", message: "To view different lifts on your lift progress graph, navigate to the More tab to update what lifts you would like to see")
        
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
        var dates = [String]()
        for i in 0..<dataPoints.count {
            // if == "lifttype" {
            //      if currentdate != details[0]
                        //j = j + 1
            //rest of the code
            let details = dataPoints[i].components(separatedBy: ",")
            if details[1].lowercased() == user!.value(forKey: "lift1") as? String {
                let value = ChartDataEntry(x: j, y: values[i])
                deadChartEntry.append(value)
                j = j + 1
            }
            else if details[1].lowercased() == user!.value(forKey: "lift2") as? String {
                let value = ChartDataEntry(x: h, y: values[i])
                squatChartEntry.append(value)
                h = h + 1
            }
            else if details[1].lowercased() == user!.value(forKey: "lift3") as? String {
                let value = ChartDataEntry(x: k, y: values[i])
                benchChartEntry.append(value)
                k = k + 1
            }
            dates.append(details[0])
        }
        //add data to the graph
        let deadline = LineChartDataSet(values: deadChartEntry, label: user!.value(forKey: "lift1") as? String)
        deadline.setColor(UIColor(red:0.00, green:0.73, blue:0.50, alpha:1.0))
        deadline.drawCirclesEnabled = false
        deadline.lineWidth = 2
        let squatline = LineChartDataSet(values: squatChartEntry, label: user!.value(forKey: "lift2") as? String)
        squatline.setColor(UIColor(red:0.00, green:0.53, blue:0.69, alpha:1.0))
        squatline.drawCirclesEnabled = false
        squatline.lineWidth = 2
        let benchline = LineChartDataSet(values: benchChartEntry, label: user!.value(forKey: "lift3") as? String)
        benchline.setColor(UIColor(red:0.87, green:0.08, blue:0.09, alpha:1.0))
        benchline.drawCirclesEnabled = false
        benchline.lineWidth = 2
        let data = LineChartData()
        data.addDataSet(deadline)
        data.addDataSet(squatline)
        data.addDataSet(benchline)
        //convert x axis to dates
        let xAxis = liftChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawLabelsEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        liftChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dates)
        liftChartView.xAxis.granularity = 1
        liftChartView.xAxis.labelCount = 5
        //add data
        liftChartView.data = data
        liftChartView.data!.setDrawValues(false)

    }
    
    func setWeightChart(dataPoints: [String], values: [Double]) {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<dataPoints.count {
            let value = ChartDataEntry(x: Double(i), y: values[i])
            lineChartEntry.append(value)
        }
        let lineChartData = LineChartDataSet(values: lineChartEntry, label: "BodyWeight")
        lineChartData.setColor(UIColor(red:0.00, green:0.53, blue:0.69, alpha:1.0))
        lineChartData.drawCirclesEnabled = false
        lineChartData.lineWidth = 2
        let data = LineChartData()
        data.addDataSet(lineChartData)
        //create proper x axis
        let xAxis = weightChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawLabelsEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        weightChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        weightChartView.xAxis.granularity = 1
        weightChartView.xAxis.labelCount = 5
        
        weightChartView.data = data
        weightChartView.data?.setDrawValues(false)
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
    
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
