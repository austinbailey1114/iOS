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

class WeightViewController: UIViewController {

    @IBOutlet weak var newWeightInput: UITextField!
    
    @IBOutlet weak var weightChartView: LineChartView!
    
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    var responseString: String?
    
    @IBOutlet weak var titleLabel2: UILabel!
    var allLifts = [String]()
    
    var user: Int32?
    var keepContext: NSManagedObjectContext?
    
    @IBOutlet weak var inputWidth: NSLayoutConstraint!
    @IBOutlet weak var inputPrompt: NSLayoutConstraint!
    @IBOutlet weak var weightChartViewWidth: NSLayoutConstraint!
    @IBOutlet weak var superWeightViewWidth: NSLayoutConstraint!
    @IBOutlet weak var titleWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set constraints
        let screenSize: CGRect = UIScreen.main.bounds
        inputWidth.constant = screenSize.width * 0.90
        inputPrompt.constant = -(inputWidth.constant / 2.0) + 100
        weightChartViewWidth.constant = screenSize.width * 0.90
        superWeightViewWidth.constant = screenSize.width * 0.90
        titleWidth.constant = screenSize.width * 0.90
        
        //add borders
        newWeightInput.addBorder(side: .bottom, thickness: 0.7, color: UIColor.lightGray)
        titleLabel2.addBorder(side: .bottom, thickness: 1.1, color: UIColor.lightGray)
        loadActivity.hidesWhenStopped = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadChart()
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
        
        loadActivity.startAnimating()
        
        let weight = self.newWeightInput.text!
        
        if newWeightInput.text! != "" && newWeightInput.text!.doubleValue != nil {
        
            DispatchQueue.global().async {
                
                self.user = TabController.currentUser
                var notFinished = false
                //hit URL with POST data of new bodyweight
                let url = URL(string: "https://www.austinmbailey.com/projects/liftappsite/api/insertBodyweight.php")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let postString = "weight=" + weight + "&id=" + String(self.user!)
                request.httpBody = postString.data(using: .utf8)
            
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
                    notFinished = true
                }
                task.resume()
            
                while !notFinished {
                    
                }
                
                DispatchQueue.main.sync {
                    self.loadChart()
                }
                
            }
            
        }
            
        else {
            createAlert(title: "Invalid Input", message: "Please make sure that your input for new body weight is a number value.")
        }
    
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
    
    func loadChart() {
        self.loadActivity.startAnimating()
        
        DispatchQueue.global().async {
            self.user = TabController.currentUser
            
            var notFinished = false
            //hit URL
            let url = URL(string: "https://www.austinmbailey.com/projects/liftappsite/api/bodyweight.php?id=" + String(self.user!))!
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
                notFinished = true
            }
            task.resume()
            
            while !notFinished {
                
            }
            //build dictionary
            let jsonData = self.responseString!.data(using: .utf8)
            let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! [Dictionary<String, Any>]
            
            
            DispatchQueue.main.sync {
                var dates = [String]()
                var bodyweight = [Double]()
                
                //build arrays for setWeightChart()
                for item in dictionary! {
                    bodyweight.append(item["weight"]! as! Double)
                    let date = item["date"] as! String
                    let dateData = date.components(separatedBy: "-")
                    let separateTime = dateData[2].components(separatedBy: " ")[0]
                    dates.append(dateData[1] + "/" + separateTime)
                }
                
                if bodyweight.count > 0 {
                    self.setWeightChart(dataPoints: dates, values: bodyweight)
                }
                
                self.loadActivity.stopAnimating()
            }
        }
    }

}
