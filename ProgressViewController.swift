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

class ProgressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var user: NSManagedObject?
    var allLifts = [String]()

    @IBOutlet weak var liftChartView: LineChartView!
    
    @IBOutlet weak var weightChartView: LineChartView!
    
    @IBOutlet weak var liftPicker: UIPickerView!
    
    @IBOutlet weak var noDataLabel: UILabel!
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
        allLifts = user!.value(forKey: "allLifts") as! [String]
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        liftChartView.isHidden = false
        noDataLabel.isHidden = true
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
        if liftChartEntry.count == 0 {
            noDataLabel.isHidden = false
            liftChartView.isHidden = true
            view.bringSubview(toFront: noDataLabel)
            return
        }
        //add data to the graph
        let liftline = LineChartDataSet(values: liftChartEntry, label: user!.value(forKey: "lift1") as? String)
        liftline.setColor(UIColor(red:0.96, green:0.47, blue:0.40, alpha:1.0))
        liftline.drawCircleHoleEnabled = false
        liftline.setCircleColor(UIColor(red:0.96, green:0.47, blue:0.40, alpha:1.0))
        if liftline.entryCount != 1 {
            liftline.drawCirclesEnabled = false
        }
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
        liftChartView.chartDescription?.text = ""
        liftChartView.data!.setDrawValues(false)

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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        allLifts = (user!.value(forKey: "allLifts") as? [String])!
        allLifts.remove(at: 1)
        let titleData = allLifts[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        allLifts = (user!.value(forKey: "allLifts") as? [String])!
        allLifts.remove(at: 1)
        return allLifts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        allLifts = (user!.value(forKey: "allLifts") as? [String])!
        allLifts.remove(at: 1)
        user!.setValue(allLifts[row], forKey: "lift1")
        
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
        
        allLifts = user!.value(forKey: "allLifts") as! [String]

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
