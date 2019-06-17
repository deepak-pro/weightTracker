//
//  ViewController.swift
//  weightTracker
//
//  Created by Deepak on 17/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import ScrollableGraphView

class ViewController: UIViewController , ScrollableGraphViewDataSource {

    @IBOutlet weak var graphView: ScrollableGraphView!
    
    let linePlotData = [68.5,68.4,69,68,68,68.5,67.5,67.4,67.1,67.9]
    var maxScale = 70
    var minScale = 66
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        case "line":
            return Double(linePlotData[pointIndex])
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "JUN \(pointIndex + 1)"
    }
    
    func numberOfPoints() -> Int {
        return linePlotData.count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.dataSource = self as! ScrollableGraphViewDataSource
        setUpGraphView()
    }

    func setUpGraphView(){
        graphView.backgroundFillColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1.0)
        graphView.tintColor = UIColor.white
        let linePlot = LinePlot(identifier: "line")
        linePlot.lineWidth = CGFloat(5.0)
        linePlot.lineColor = UIColor.white
        linePlot.lineStyle = .smooth
        linePlot.shouldFill = true
        linePlot.fillType = .gradient
        linePlot.fillColor = UIColor.red
        linePlot.fillGradientStartColor = UIColor.white
        linePlot.fillGradientEndColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1.0)
        linePlot.fillGradientType = .linear
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.easeOut
        linePlot.animationDuration = Double(0.5)
        
        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.white
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let referenceLines = ReferenceLines()
        referenceLines.dataPointLabelColor = UIColor.white
        referenceLines.referenceLineColor = UIColor.white
        referenceLines.referenceLineLabelColor = UIColor.white
        
        
        graphView.shouldAdaptRange = false
        graphView.rangeMax = Double(maxScale)
        graphView.rangeMin = Double(minScale)
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

