//
//  CardViewController.swift
//  weightTracker
//
//  Created by Deepak on 19/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import AudioToolbox
import RealmSwift

class CardViewController: UIViewController  , UIPickerViewDelegate , UIPickerViewDataSource{
    
    @IBOutlet weak var handleLabel: UILabel!
    
    let realm = try! Realm()
    
    var weightArray = [Int]()
    var pointArray = [Int]()
    var finalWeight = Double()
    var finalWeightKGComponent = Int()
    var finalWeightMGComponent = Int()
    var previousWeight = 86.5
    var selectComponent = 0
    var selectWeight = 0
    var newCaseID = Int()
    var id : Int = 0
    @IBOutlet weak var doneButtonOut: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return weightArray.count
        }else {
            return pointArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String("\(weightArray[row]) kg")
        }else {
            return String(pointArray[row])
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = "myString"
        if component == 0 {
            string = String("\(weightArray[row]) kg")
        }else {
            string = String(pointArray[row])
        }
        
        
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white , NSAttributedString.Key.font: UIFont(name: "AvenirNextCondensed-Regular", size: 24.0)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Component is \(component) , row is \(row)")
        if(component == 0) {
            finalWeightKGComponent = weightArray[row]
        }else{
            finalWeightMGComponent = pointArray[row]
        }
        weightLabel.text = "\(finalWeightKGComponent).\(finalWeightMGComponent) kg"
        doneButtonOut.layer.borderColor = UIColor.white.cgColor
        doneButtonOut.layer.borderWidth = 2.0
        doneButtonOut.backgroundColor = UIColor.clear
        doneButtonOut.setTitle("Save", for: .normal)
        finalWeight = Double(finalWeightKGComponent) + (Double(finalWeightMGComponent) * 0.1)
    }
    
    func extractComponentFromPreviousWeight(){
        var previousWeightIntValue = Int(previousWeight)
        finalWeightMGComponent = Int((previousWeight - Double(previousWeightIntValue)) * 10) + 1
        print(finalWeightMGComponent)
        finalWeightKGComponent = Int(previousWeight/1)
        print(finalWeightKGComponent)
        weightLabel.text = "\(finalWeightKGComponent).\(finalWeightMGComponent) kg"
        finalWeight = Double(finalWeightKGComponent) + (Double(finalWeightMGComponent) * 0.1)
    }
    
    func setPreviousWeight(){
        weightPickerView.selectRow(finalWeightKGComponent - 40, inComponent: 0, animated: true)
        weightPickerView.selectRow(finalWeightMGComponent, inComponent: 1, animated: true)
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
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var weightPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var weightNumber = 40
        for number in 1...80 {
            weightArray.append((weightNumber))
            weightNumber = weightNumber + 1
        }
        for number in 0...9 {
            pointArray.append(number)
        }
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
        extractComponentFromPreviousWeight()
        setPreviousWeight()
        doneButtonOut.layer.cornerRadius = 20.0
        doneButtonOut.clipsToBounds = true
        doneButtonOut.layer.borderColor = UIColor.white.cgColor
        doneButtonOut.layer.borderWidth = 2.0
        doneButtonOut.tintColor = UIColor.white
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    func checkRedundancy(){
        if(getLastUpdateDate() != nil){
            if(formatDate(date: Date()) == formatDate(date: getLastUpdateDate()!)) {
                print("Record Existed for today")
                var objectToRemove = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: false).first
                if(objectToRemove != nil){
                    try! realm.write {
                        realm.delete(objectToRemove!)
                    }
                }
                
                
            }else {
                print("Record Not existed for today")
            }
        }else {
            print("Record Not Existed")
        }
        
    }
    
    func formatDate(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func getLastUpdateDate() -> Date? {
        var ldate : Date?
        ldate = (realm.objects(Record.self).sorted(byKeyPath: "date", ascending: false).first?.date ?? nil)
        return ldate
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let blueShade = UIColor(red: 0/255, green: 134/255, blue: 206/255, alpha: 1.0)
        
        doneButtonOut.backgroundColor = blueShade
        doneButtonOut.setTitle("Saved", for: .normal)
        doneButtonOut.layer.borderWidth = 0.00
        
        print("Saving Records")
        checkRedundancy()
        let newRecord = Record()
        newRecord.date = Date()
        newRecord.weight = Double(finalWeight)
        newRecord.id = getCaseID()
        try! realm.write {
            realm.add(newRecord)
        }
        
        
    }
    
    @IBAction func saveTouchDown(_ sender: Any) {
        AudioServicesPlaySystemSound(1519)
    }
    


}
