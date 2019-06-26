//
//  TodayViewController.swift
//  Latest Updated Weight
//
//  Created by Deepak on 26/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        
    }
    
    func formatDate(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM  dd,  yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    
    
    func updateLabels(){
        if let userDefaults = UserDefaults(suiteName: "group.Deepak.weightTracker"){
            
            let dateValue = userDefaults.string(forKey: "finalDate")
            let weightValue = userDefaults.string(forKey: "finalWeight")
            
            dateLabel.text = dateValue
            weightlabel.text = weightValue
        }else {
            print("ERROR")
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
