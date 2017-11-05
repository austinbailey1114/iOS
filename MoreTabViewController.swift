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
    
    var responseString: String?
    
    @IBOutlet weak var titleLabel2: UILabel!
    var allLifts = [String]()
    
    var user: Int32?
    var keepContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        //UILabel.appearance().font = UIFont(name: "System-Light", size: 17)
        
        
        
        user = TabController.currentUser
        
        let url = URL(string: "http://www.austinmbailey.com/projects/liftappsite/api/bodyweight.php?id" + String(TabController.currentUser!))!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response")
            }
            
            self.responseString = String(data: data, encoding: .utf8)
        }
        task.resume()
        
        print(convertToDictionary(text: responseString!))
        
        //build bodyweight graph
        /*
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
 
        newWeightInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        titleLabel2.addBorder(side: .bottom, thickness: 1.1, color: UIColor.lightGray)
        
        
        if bodyweight.count > 0 {
            setWeightChart(dataPoints: dates, values: bodyweight)
        }
        
        */


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //update users bodyweight when they hit save button
    @IBAction func updateWeightButton(_ sender: UIButton) {
        /*if newWeightInput.text! != "" && newWeightInput.text!.doubleValue != nil {
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

    */
    }
    
    //create alerts
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
    
    //build the chart to display bodyweight over time
    func setWeightChart(dataPoints: [String], values: [Double]) {
        var lineChartEntry = [ChartDataEntry]()
        //build array of data entries
        for i in 0..<dataPoints.count {
            let value = ChartDataEntry(x: Double(i), y: values[i])
            lineChartEntry.append(value)
        }
        //formatting
        let lineChartData = LineChartDataSet(values: lineChartEntry, label: "BodyWeight")
        lineChartData.setColor(UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0))
        lineChartData.drawCirclesEnabled = false
        lineChartData.lineWidth = 2
        lineChartData.mode = .cubicBezier
        lineChartData.cubicIntensity = 0.2
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
        lineChartData.drawFilledEnabled = true
        lineChartData.fill = Fill.fillWithColor(UIColor(red:0.91, green:0.30, blue:0.24, alpha:0.6))
        weightChartView.animate(yAxisDuration: 1.3, easingOption: .easeOutQuart)
        weightChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        weightChartView.xAxis.granularity = 1
        weightChartView.xAxis.labelCount = 5
        weightChartView.data = data
        weightChartView.chartDescription?.text! = ""
        weightChartView.data?.setDrawValues(false)
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
