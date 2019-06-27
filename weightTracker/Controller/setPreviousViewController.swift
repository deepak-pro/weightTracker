//
//  setPreviousViewController.swift
//  weightTracker
//
//  Created by Deepak on 27/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class setPreviousViewController: UIViewController , FSCalendarDelegate , FSCalendarDataSource  {

    fileprivate weak var calender : FSCalendar!
    let realm = try! Realm()
    @IBOutlet weak var weightTextFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func setUpCalenderView(_ sender: Any) {
        let calender = FSCalendar(frame:CGRect(x: 0, y: 100, width: self.view.frame.width, height: 400))
        calender.dataSource = self
        calender.delegate = self
        calender.backgroundColor = UIColor.white
        calender.layer.cornerRadius = CGFloat(20.0)
        
        calender.layer.shadowColor = UIColor.gray.cgColor
        calender.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        calender.layer.shadowRadius = 12.0
        calender.layer.shadowOpacity = 0.7
        
        calender.appearance.headerTitleColor = UIColor(displayP3Red: 0/255, green: 138/255, blue: 202/255, alpha: 1.0)
        calender.appearance.weekdayTextColor = UIColor(displayP3Red: 0/255, green: 138/255, blue: 202/255, alpha: 1.0)
        
        view.addSubview(calender)
        self.calender = calender
        
        calender.translatesAutoresizingMaskIntoConstraints = false
        calender.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        calender.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        calender.heightAnchor.constraint(equalToConstant: 400).isActive = true
        calender.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        // Can animate popup
    }
    
    
    @IBAction func addDate(_ sender: Any) {
        let newRecord = Record()
        newRecord.date = calender.selectedDate
        newRecord.weight = Double(weightTextFeild.text!)!
        newRecord.id = 1
        try! realm.write {
            realm.add(newRecord)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
