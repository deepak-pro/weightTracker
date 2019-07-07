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

class setPreviousViewController: UIViewController , FSCalendarDelegate , FSCalendarDataSource , UITextFieldDelegate  {

    fileprivate weak var calender : FSCalendar!
    @IBOutlet weak var selectDateButton: UIButton!
    let realm = try! Realm()
    @IBOutlet weak var weightTextFeild: UITextField!
    var selectedDate : Date?
    
    var newCaseID = Int()
    var id : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightTextFeild.delegate = self
        weightTextFeild.returnKeyType = .done
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.weightTextFeild.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        weightTextFeild.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        selectDateButton.setTitle(formatDate(date: selectedDate!), for: .normal)
        calendar.removeFromSuperview()
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
        calender.translatesAutoresizingMaskIntoConstraints = false
        calender.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        calender.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        calender.heightAnchor.constraint(equalToConstant: 400).isActive = true
        calender.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    
    func formatDate(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM  dd,  yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func getCaseID() -> Int {
        newCaseID = 1
        if (UserDefaults.standard.object(forKey: "caseID") as? Int == nil ){
            UserDefaults.standard.set(1, forKey: "caseID")
            print("Case Id variable created.")
        }else{
            id = UserDefaults.standard.object(forKey: "caseID") as! Int
            newCaseID = id + 1
            UserDefaults.standard.set(newCaseID , forKey: "caseID")
        }
        return (newCaseID)
    }
    
    func checkRedundancy(forDate : Date){
        let resultDates = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: false)
        for result in resultDates {
            if formatDate(date: forDate) == formatDate(date: result.date!){
                print("✅ Record Existed")
                let toDelete = realm.objects(Record.self).filter("id = \(result.id)")
                print(toDelete)
                try! realm.write {
                    realm.delete(toDelete)
                    print("Redundant record Deleted")
                }
                return
            }
        }
        print(" ❌ Record Not Existed")
    }
    
    
    @IBAction func addDate(_ sender: Any) {
        if selectedDate == nil {
            let alert = UIAlertController(title: "Please select date", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            present(alert ,animated: true , completion: nil)
            return
        }
        if weightTextFeild.text!.isEmpty{
            let alert = UIAlertController(title: "Please enter weight", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            present(alert ,animated: true , completion: nil)
            return
        }
        checkRedundancy(forDate: selectedDate!)
        let newRecord = Record()
        newRecord.id = getCaseID()
        newRecord.date = selectedDate
        newRecord.weight = Double(weightTextFeild.text!)!
        try! realm.write {
            realm.add(newRecord)
            let alert = UIAlertController(title: "Record added successfully", message: "Statitics are now updated", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert,animated: true , completion: nil)
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
