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
            xvalues.append(dateData[1] + "/" + dateData[0] + "," + details[2] + "," + String(calculateMax(weight: details[0], reps: details[1])))
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
        if bodyweight.count > 0 {
            setWeightChart(dataPoints: dates, values: bodyweight)
        }

        createAlert(title: "View A Different Lift", message: "To view a different lift on the lift history graph, head to the More tab under Update Graphed Lift.")
        
    }
    func setChart(dataPoints: [String], values: [Double]) {
        //create data entries for each lift
        var liftChartEntry = [ChartDataEntry]()
        var dates = [String]()
        dates.append("")
        //strings to track most recent date of each lift
        var currentDate = ""
        var currentIndex = 0
        for i in 0..<dataPoints.count {
            //if date is == current date
            //  if this.calculatemax > the other point that already exists
            //      replace the point
            //if its !=, increment the value before plotting
            let details = dataPoints[i].components(separatedBy: ",")
            if details[1] == user!.value(forKey: "lift1") as? String {
                if details[0] == currentDate {
                    if liftChartEntry.last!.y < Double(details[2])! {
                        liftChartEntry.removeLast()
                        let value = ChartDataEntry(x: Double(currentIndex), y: Double(details[2])!)
                        liftChartEntry.append(value)
                    }
                }
                else {
                    currentIndex += 1
                    let value = ChartDataEntry(x: Double(currentIndex), y: Double(details[2])!)
                    liftChartEntry.append(value)
                    currentDate = details[0]
                    dates.append(details[0])
                }

            }
        }
        //add data to the graph
        /*let deadline = LineChartDataSet(values: deadChartEntry, label: user!.value(forKey: "lift1") as? String)
        deadline.setColor(UIColor(red:0.00, green:0.73, blue:0.50, alpha:1.0))
        deadline.drawCirclesEnabled = false
        deadline.lineWidth = 2*/
        let liftline = LineChartDataSet(values: liftChartEntry, label: user!.value(forKey: "lift1") as? String)
        liftline.setColor(UIColor(red:0.96, green:0.47, blue:0.40, alpha:1.0))
        liftline.drawCirclesEnabled = false
        liftline.lineWidth = 2
        let data = LineChartData()
        data.addDataSet(liftline)
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
    
    override func viewWillAppear(_ animated: Bool) {
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
            xvalues.append(dateData[1] + "/" + dateData[0] + "," + details[2] + "," + String(calculateMax(weight: details[0], reps: details[1])))
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
        
        createAlert(title: "View A Different Lift", message: "To view a different lift on the lift history graph, head to the More tab under Update Graphed Lift.")

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
