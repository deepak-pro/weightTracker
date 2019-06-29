//
//  selectDatesViewController.swift
//  weightTracker
//
//  Created by Deepak on 25/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import AudioToolbox
import FSCalendar

var startDate : Date?
var endDate : Date?

class selectDatesViewController: UIViewController , FSCalendarDelegate , FSCalendarDataSource {
    
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    
    var selectedDate : Date?
    var editingDate : String?
    
    
    
    fileprivate weak var calender : FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setUpCalender(){
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
        calender.appearance.headerTitleFont = startDateButton.titleLabel?.font
        
        view.addSubview(calender)
        self.calender = calender
        
        calender.translatesAutoresizingMaskIntoConstraints = false
        calender.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        calender.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        calender.heightAnchor.constraint(equalToConstant: 400).isActive = true
        calender.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        calender.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            self.calender.transform = .identity
        })
        
        // Can animate popup
        
        
    }
    
    func setDate() {
        
    }
    
    @IBAction func startDateAction(_ sender: Any) {
        editingDate = "start"
        setUpCalender()
    }
    
    
    @IBAction func endDateAction(_ sender: Any) {
        editingDate = "end"
        setUpCalender()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if(editingDate=="start"){
            startDate = date
            startDateButton.setTitle(formatDate(date: date), for: .normal)
        }else if editingDate == "end" {
            endDate = date
            endDateButton.setTitle(formatDate(date: date), for: .normal)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.calender.alpha = 0
        }) { (success) in
            self.calender.removeFromSuperview()
        }
        
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
    func formatDate(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM  dd,  yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectDate() {
        
    }
    
    @IBAction func showHistoryTapped(_ sender: Any) {
        
        
        if(startDate != nil && endDate != nil){
            
        }else {
            let alert = UIAlertController(title: "Please select a valid range", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            present(alert,animated: true ,completion: nil)
            return
        }
        
        if(startDate! > endDate!) {
            let alert = UIAlertController(title: "Please select a valid range", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            present(alert,animated: true ,completion: nil)
            return
        }
        
        
        
        performSegue(withIdentifier: "showDatesHistory", sender: self)
        
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
}
