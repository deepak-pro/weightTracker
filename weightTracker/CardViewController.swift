//
//  CardViewController.swift
//  weightTracker
//
//  Created by Deepak on 19/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit

class CardViewController: UIViewController  , UIPickerViewDelegate , UIPickerViewDataSource{
    
    var weightArray = [Int]()
    var pointArray = [Int]()
    var finalWeight = Float()
    var finalWeightKGComponent = Int()
    var finalWeightMGComponent = Int()
    var previousWeight = 86.5
    var selectComponent = 0
    var selectWeight = 0
    
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
    }
    
    func extractComponentFromPreviousWeight(){
        var previousWeightIntValue = Int(previousWeight)
        finalWeightMGComponent = Int((previousWeight - Double(previousWeightIntValue)) * 10) + 1
        print(finalWeightMGComponent)
        finalWeightKGComponent = Int(previousWeight/1)
        print(finalWeightKGComponent)
        weightLabel.text = "\(finalWeightKGComponent).\(finalWeightMGComponent) kg"
    }
    
    func setPreviousWeight(){
        weightPickerView.selectRow(finalWeightKGComponent - 40, inComponent: 0, animated: true)
        weightPickerView.selectRow(finalWeightMGComponent, inComponent: 1, animated: true)
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
    }
    


}
