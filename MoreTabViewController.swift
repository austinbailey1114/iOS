//
//  MoreTabViewController.swift
//  LiftApp
//
//  Created by Austin Bailey on 8/9/17.
//  Copyright © 2017 Austin Bailey. All rights reserved.
//

import UIKit
import CoreData
import Charts

class MoreTabViewController: UIViewController {

    @IBOutlet weak var newWeightInput: UITextField!
    
    @IBOutlet weak var weightChartView: LineChartView!
    
    var allLifts = [String]()
    
    var user: NSManagedObject?
    var keepContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        user = TabController.currentUser
        allLifts = (user!.value(forKey: "allLifts") as? [String])!
        
        //build bodyweight graph
        print("here0")
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


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateWeightButton(_ sender: UIButton) {
        if newWeightInput.text! != "" && newWeightInput.text!.doubleValue != nil {
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
        else {
            createAlert(title: "Invalid Input", message: "Please make sure that your input for new body weight is a number value.")
        }
        
        //rebuild chart
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func setWeightChart(dataPoints: [String], values: [Double]) {
        print("made it here")
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
        print("herezero")
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
        weightChartView.chartDescription?.text! = ""
        weightChartView.data?.setDrawValues(false)
        print("here1")
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
