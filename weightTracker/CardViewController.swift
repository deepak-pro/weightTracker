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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Component is \(component) , row is \(row)")
        if(component == 0) {
            finalWeightKGComponent = weightArray[row]
        }else{
            finalWeightMGComponent = pointArray[row]
        }
        weightLabel.text = "\(finalWeightKGComponent).\(finalWeightMGComponent) kg"
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
        weightPickerView.setValue(UIColor.white, forKey: "textColor")
    }


}
