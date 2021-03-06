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

class LiftProgressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var user: Int32?
    var allLifts = [String]()

    @IBOutlet weak var liftChartView: LineChartView!
    
    @IBOutlet weak var weightChartView: LineChartView!
    
    @IBOutlet weak var liftPicker: UIPickerView!
    
    @IBOutlet weak var graphBackground: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var graphBackgroundWidth: NSLayoutConstraint!
    @IBOutlet weak var pickerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var liftChartWidth: NSLayoutConstraint!
    //create global variables for graph data
    var xvalues: [String]?
    var yvalues: [Double]?
    var types: [String]?
    
    var responseString: String?
    var displayingType: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        titleLabelWidth.constant = screenSize.width * 0.90
        graphBackgroundWidth.constant = screenSize.width * 0.90
        pickerViewWidth.constant = screenSize.width * 0.90
        liftChartWidth.constant = screenSize.width * 0.90
        
        
        loadActivity.hidesWhenStopped = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadActivity.startAnimating()
        
        DispatchQueue.global().async {
            self.xvalues = []
            self.yvalues = []
            self.types = []
            
            //GET data for graphs
            self.user = TabController.currentUser
            //hit URL for lifts
            var notFinished = false
            var url = URL(string: "https://austinmbailey.com/projects/liftappsite/api/lift.php?id=" + String(self.user!))!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            var task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                }
                
                self.responseString = String(data: data, encoding: .utf8)
                notFinished = true
            }
            task.resume()
            
            while !notFinished {
                
            }
            
            //build dictionary of lift data
            var jsonData = self.responseString!.data(using: .utf8)
            var dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! [Dictionary<String, Any>]
            
            for item in dictionary! {
                self.yvalues!.append(self.calculateMax(weight: item["weight"] as! Double, reps: item["reps"] as! Double))
                let date = item["date"] as! String
                let dateData = date.components(separatedBy: "-")
                let separateTime = dateData[2].components(separatedBy: " ")[0]
                self.xvalues!.append(dateData[1] + "/" + separateTime)
                self.types!.append(item["type"] as! String)
            }
            
            //GET lifttypes for picker view
            self.user = TabController.currentUser
            notFinished = false
            //hit URL for lifttypes
            url = URL(string: "https://austinmbailey.com/projects/liftappsite/api/lifttypes.php?id=" + String(self.user!))!
            request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                }
                
                self.responseString = String(data: data, encoding: .utf8)
                notFinished = true
            }
            task.resume()
            
            while !notFinished {
                
            }
            
            DispatchQueue.main.sync {
                
                
                //build dictionary of users lifttypes
                jsonData = self.responseString!.data(using: .utf8)
                dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! [Dictionary<String, Any>]
                
                for item in dictionary! {
                    self.allLifts.append(String(describing: item["name"]!))
                }
                
                if self.allLifts.count > 0 {
                    self.displayingType = self.allLifts[0]
                }
                
                self.setChart(dates: self.xvalues!, values: self.yvalues!, types: self.types!)
                
                self.liftPicker.reloadAllComponents()
                
                self.loadActivity.stopAnimating()
            }
                
        }
            
    }
    
    //use iOS Charts to build the chart with the gathered data
    func setChart(dates: [String], values: [Double], types: [String]) {
        if dates.count == 0  || displayingType == nil {
            noDataLabel.isHidden = false
            view.bringSubview(toFront: noDataLabel)
            return
        }
        liftChartView.isHidden = false
        noDataLabel.isHidden = true
        //create data entries for each lift
        var liftChartEntry = [ChartDataEntry]()
        var xaxis = [String]()
        var currentIndex = 0
        //loop through each item
        for i in 0..<dates.count {
            //if it is of the correct type
            if types[i] == displayingType! {
                //if the array is not empty
                if xaxis.count > 0 {
                    //if the current item has the same date
                    if dates[i] == xaxis[xaxis.count-1] {
                        //if the previous item in the graph is smaller than the current element, replace it
                        if liftChartEntry.last!.y < values[i] {
                            liftChartEntry.removeLast()
                            let value = ChartDataEntry(x: Double(currentIndex-1), y: values[i])
                            liftChartEntry.append(value)
                        }
                    }
                    else {
                        let value = ChartDataEntry(x: Double(currentIndex), y: values[i])
                        liftChartEntry.append(value)
                        xaxis.append(dates[i])
                        currentIndex += 1
                    }
                }
                else {
                    let value = ChartDataEntry(x: Double(currentIndex), y: values[i])
                    liftChartEntry.append(value)
                    xaxis.append(dates[i])
                    currentIndex += 1
                }
            }
        }
        //add data to the graph
        let liftline = LineChartDataSet(values: liftChartEntry, label: displayingType!.replacingOccurrences(of: "_", with: " ") as? String)
        liftline.setColor(UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0))
        liftline.drawCircleHoleEnabled = false
        liftline.setCircleColor(UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0))
        if liftline.entryCount != 1 {
            liftline.drawCirclesEnabled = false
        }
        //set a bunch of visual options
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
        liftChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xaxis)
        liftChartView.xAxis.granularity = 1
        liftChartView.xAxis.labelCount = 5
        liftChartView.animate(yAxisDuration: 1.3, easingOption: .easeOutQuart)
        liftline.drawFilledEnabled = true
        liftline.fill = Fill.fillWithColor(UIColor(red:0.91, green:0.30, blue:0.24, alpha:0.6))
        liftline.mode = .cubicBezier
        liftline.cubicIntensity = 0.2
        
        
        //add data
        liftChartView.data = data
        liftChartView.chartDescription?.text = ""
        liftChartView.data!.setDrawValues(false)

    }
    
    //calculate one rep max
    func calculateMax(weight: Double, reps: Double) -> Double {
        let weight = Double(weight)
        let reps = Double(reps)
        return (weight*(1+(reps/30)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //create alerts
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //set number of components in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        
        // where data is an Array of String
        label.text = allLifts[row].replacingOccurrences(of: "_", with: " ")
        
        return label
    }
    
    //set size of picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allLifts.count
    }
    
    //handle user interaciton with picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        displayingType = allLifts[row].replacingOccurrences(of: " ", with: "_")
        setChart(dates: xvalues!, values: yvalues!, types: types!)
    }

}
