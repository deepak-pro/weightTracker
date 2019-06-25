//
//  selectDatesViewController.swift
//  weightTracker
//
//  Created by Deepak on 25/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import AudioToolbox

class selectDatesViewController: UIViewController {
    
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    
    var selectingFor = ""
    var startDate : Date?
    var endDate : Date?

    var aPopupContainer: PopupContainer?
    var testCalendar = Calendar(identifier: Calendar.Identifier.iso8601)
    
    var currentDate: Date! = Date() {
        didSet {
            setDate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate = Date()
    }
    
    func setDate() {
        if selectingFor == "start" {
            startDate = currentDate
            startDateButton.setTitle(formatDate(date: currentDate), for: .normal)
        }else if selectingFor == "end" {
            endDate = currentDate
            endDateButton.setTitle(formatDate(date: currentDate), for: .normal)
        }else {
            
        }
    }
    
    @IBAction func startDateAction(_ sender: Any) {
        selectingFor = "start"
        selectDate()
    }
    
    
    @IBAction func endDateAction(_ sender: Any) {
        selectingFor = "end"
        selectDate()
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
        AudioServicesPlaySystemSound(1519)
        let xibView = Bundle.main.loadNibNamed("CalendarPopUp", owner: nil, options: nil)?[0] as! CalendarPopUp
        xibView.calendarDelegate = self
        xibView.selected = currentDate
        xibView.startDate = Calendar.current.date(byAdding: .month, value: -12, to: Date())!
        xibView.endDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())!

        print(Calendar.current.date(byAdding: .month, value: -24, to: currentDate)!)
        print(Calendar.current.date(byAdding: .year, value: 2, to: currentDate)!)
        
        PopupContainer.generatePopupWithView(xibView).show()
    }
    
    @IBAction func showHistoryTapped(_ sender: Any) {
        if startDate != nil && endDate != nil {
            
            if(startDate! > endDate!){
                let alert = UIAlertController(title: "Please select valid range", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                present(alert,animated:true,completion: nil)
                return
            }
            
            print("Start date is \(startDate)")
            print("End date is \(endDate)")
        }else {
            let alert = UIAlertController(title: "Please select valid range", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            present(alert,animated:true,completion: nil)
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

extension selectDatesViewController: CalendarPopUpDelegate {
    func dateChaged(date: Date) {
        currentDate = date
    }
}
