//
//  ViewController.swift
//  weightTracker
//
//  Created by Deepak on 17/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import ScrollableGraphView
import AudioToolbox
import RealmSwift

class ViewController: UIViewController , ScrollableGraphViewDataSource , UIViewControllerTransitioningDelegate {

    @IBOutlet weak var graphView: ScrollableGraphView!
    
    var linePlotData : [Double] = [1,2]
    var linePlotScale = ["a","b"]
    var maxScale : Double = 70
    var minScale : Double = 66
    
    let realm = try! Realm()
    
    @IBOutlet weak var latestWeightLabel: UILabel!
    @IBOutlet weak var latestDateLabel: UILabel!
    @IBOutlet weak var weekWeightLabel: UILabel!
    @IBOutlet weak var monthWeightLabel: UILabel!
    @IBOutlet weak var yearWeightLabel: UILabel!
    
    @IBOutlet weak var weekArrow: UIImageView!
    @IBOutlet weak var monthArrow: UIImageView!
    @IBOutlet weak var yearArrow: UIImageView!
    
    
    @IBOutlet weak var scaleSegment: UISegmentedControl!
    @IBOutlet weak var menuButton: UIButton!
    let transition = CircularTransition()
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardViewController : CardViewController!
//    var visualEffectView: UIVisualEffectView!
    
    let cardHeight:CGFloat = 400
    let cardHandleAreaHeight : CGFloat = 80
    
    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations  = [UIViewPropertyAnimator]()
    var animationProgresWhenInterrupted:CGFloat = 0
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        case "line":
            return Double(linePlotData[pointIndex])
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return linePlotScale[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return linePlotData.count
    }
    
    func updatelatestWeightlabel(){
        if let latestWeight = UserDefaults.standard.object(forKey: "latestWeight") as? Double{
            latestWeightLabel.text = String(latestWeight) + " kg"
        }else {
            latestWeightLabel.text = "--"
        }
        if let latestDate = UserDefaults.standard.object(forKey: "latestDate") as? Date {
            latestDateLabel.text = formatDate(date: latestDate)
        }else {
            latestDateLabel.text = "--"
        }
    }
    
    func formatDate(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM  dd,  yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func formatDateW(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        let result = formatter.string(from: date)
        return result
    }
    
    func formatDateM(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        let result = formatter.string(from: date)
        return result
    }
    
    func loadWeekAnalytics(){
        print("Creating Week Chart")
        if let latestWeight = UserDefaults.standard.object(forKey: "latestWeight") as? Double{
            if let latestDate = UserDefaults.standard.object(forKey: "latestDate") as? Date {
                let previousWeekDate = Calendar.current.date(byAdding: .day, value: -7, to: latestDate)
                let results = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: true).filter("date BETWEEN {%@, %@}",previousWeekDate,latestDate)
                linePlotData.removeAll()
                linePlotScale.removeAll()
                for i in results {
                    linePlotData.append(i.weight)
                    linePlotScale.append(formatDateW(date: i.date!).uppercased())
                }
                
                maxScale = linePlotData.max()! + Double(1)
                minScale = linePlotData.min()! - Double(1)
                for i in 1...30{
                    linePlotData.append(minScale)
                    linePlotScale.append("")
                }
                print(maxScale,minScale)
                graphView.rangeMax = maxScale
                graphView.rangeMin = minScale
                graphView.reload()
            }
        }
        
        
    }
    
    func loadMonthAnalytics(){
        print("Creating Month Chart")
        
        if let latestWeight = UserDefaults.standard.object(forKey: "latestWeight") as? Double{
            if let latestDate = UserDefaults.standard.object(forKey: "latestDate") as? Date {
                
                let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: latestDate)
                let results = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: true).filter("date BETWEEN {%@, %@}" , previousMonthDate, latestDate)
                linePlotData.removeAll()
                linePlotScale.removeAll()
                
                for i in results {
                    linePlotData.append(i.weight)
                    linePlotScale.append(formatDateW(date: i.date!).uppercased())
                }
                print(linePlotScale,linePlotData)
                maxScale = linePlotData.max()! + Double(1)
                minScale = linePlotData.min()! - Double(1)
                for i in 1...30{
                    linePlotData.append(minScale)
                    linePlotScale.append("")
                }
                print(maxScale,minScale)
                graphView.rangeMax = maxScale
                graphView.rangeMin = minScale
                graphView.reload()
            }
        }
        
    }
    
    func loadYearAnalytics(){
        print("Creating Year chart")
        
        if let latestWeight = UserDefaults.standard.object(forKey: "latestWeight") as? Double{
            if let latestDate = UserDefaults.standard.object(forKey: "latestDate") as? Date {
                linePlotData.removeAll()
                linePlotScale.removeAll()
                var sv = -12
                while (sv != 0){
                    let sd = Calendar.current.date(byAdding: .month, value: sv, to: latestDate)
                    let ed = Calendar.current.date(byAdding: .month, value: sv + 1, to: latestDate)
                    print("Finding Values between",sd,ed)
                    let result = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: true).filter("date BETWEEN {%@, %@}",sd,ed).first
                    if result != nil {
                        linePlotData.append((result?.weight)!)
                        linePlotScale.append(formatDateM(date: (result?.date)!))
                    }
                    sv = sv + 1
                }
                
                print(linePlotScale,linePlotData)
                maxScale = linePlotData.max()! + Double(1)
                minScale = linePlotData.min()! - Double(1)
                for i in 1...30{
                    linePlotData.append(minScale)
                    linePlotScale.append("")
                }
                print(maxScale,minScale)
                graphView.rangeMax = maxScale
                graphView.rangeMin = minScale
                graphView.reload()
            }
        }
        
    }
    
    func loadChartAnalytics(){
        if scaleSegment.selectedSegmentIndex == 0 {
            loadWeekAnalytics()
        } else if scaleSegment.selectedSegmentIndex == 1 {
            loadMonthAnalytics()
        } else if scaleSegment.selectedSegmentIndex == 2 {
            loadYearAnalytics()
        }
    }
    
    
    func loadStackAnalytics(){
        if let latestWeight = UserDefaults.standard.object(forKey: "latestWeight") as? Double{
            if let latestDate = UserDefaults.standard.object(forKey: "latestDate") as? Date {
                
                let lastWeekDate = Calendar.current.date(byAdding: .day, value: -7 , to: latestDate)
                let lastWeekWeight = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: true).filter("date BETWEEN {%@, %@}", lastWeekDate , latestDate).first?.weight
                if lastWeekWeight != nil {
                    print("Last week weight was \(lastWeekWeight) of date\(lastWeekDate)")
                    let differenceInWeek = latestWeight - lastWeekWeight!
                    if differenceInWeek < 0 {
                        weekArrow.image = UIImage(named: "greenDecrease")
                    }else if differenceInWeek > 0 {
                        weekArrow.image = UIImage(named: "redIncrease")
                    }
                    weekWeightLabel.text = String(Double(round(10 * differenceInWeek)/10)) + " kg"
                }else {
                    weekWeightLabel.text = "-----"
                }
                
                let lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: latestDate)
                let lastMonthWeight = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: true).filter("date BETWEEN {%@, %@}", lastMonthDate, latestDate).first?.weight
                if lastWeekWeight != nil {
                    print("Last Month date is \(lastMonthDate) and weight is \(lastMonthWeight)")
                    let differenceInMonth = latestWeight - lastMonthWeight!
                    if differenceInMonth < 0 {
                        monthArrow.image = UIImage(named: "greenDecrease")
                    } else if differenceInMonth > 0 {
                        monthArrow.image = UIImage(named: "redIncrease")
                    }
                    monthWeightLabel.text = String(Double(round(10 * differenceInMonth)/10)) + " kg"
                }else {
                    monthWeightLabel.text = "-----"
                }
                
                let lastYearDate = Calendar.current.date(byAdding: .year, value: -1 , to: latestDate)
                let lastYearWeight = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: true).filter("date BETWEEN {%@, %@}",lastYearDate,latestDate).first?.weight
                if lastYearWeight != nil {
                    print("Last year date is \(lastYearDate) and weight is \(lastYearWeight)")
                    let differenceInYear = latestWeight - lastYearWeight!
                    if differenceInYear < 0 {
                        yearArrow.image = UIImage(named: "greenDecrease")
                    } else if differenceInYear > 0 {
                        yearArrow.image = UIImage(named: "redIncrease")
                    }
                    yearWeightLabel.text = String(Double(round(10 * differenceInYear)/10)) + " kg"
                }
                
                
                
            }
        }else {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatelatestWeightlabel()
        maxScale = linePlotData.max() ?? 150 + Double(5)
        minScale = linePlotData.min() ?? 50 - Double(5)
        
        graphView.dataSource = self as ScrollableGraphViewDataSource
        setUpGraphView()
        setUpCard()
        loadStackAnalytics()
        loadChartAnalytics()
        self.cardViewController.view.layer.cornerRadius = 0
        
    }
    
    func setUpCard(){
        
        cardViewController = CardViewController(nibName: "CardViewController" , bundle : nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight , width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognzier = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognzier:)))
        let panGestureRecognzier = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognzier:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognzier)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognzier)
        
        
    }
    
    @objc
    func handleCardTap(recognzier : UITapGestureRecognizer){
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.6)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan (recognzier : UIPanGestureRecognizer){
        switch recognzier.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.6)
        case .changed :
            let translation = recognzier.translation(in : self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateIntervalTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractivetransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state : CardState , duration : TimeInterval){
        
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case.expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
                
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiuAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                    self.updatelatestWeightlabel()
                    self.loadChartAnalytics()
                }
            }
            
            cornerRadiuAnimator.startAnimation()
            runningAnimations.append(cornerRadiuAnimator)
            
//            let blurAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
//                switch state {
//                case .expanded:
////                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
////                    self.visualEffectView.alpha  = 0.7
//                case .collapsed:
////                    self.visualEffectView.effect = nil
//                }
//            }
//
////            blurAnimator.startAnimation()
////            runningAnimations.append(blurAnimator)
            
        }
        
    }
    
    func startInteractiveTransition(state:CardState , duration: TimeInterval){
        
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
            
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgresWhenInterrupted = animator.fractionComplete
        }
        
    }
    
    func updateIntervalTransition(fractionCompleted : CGFloat){
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgresWhenInterrupted
        }
        
    }
    
    func continueInteractivetransition(){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    

    func setUpGraphView(){
        graphView.backgroundFillColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1.0)
        graphView.tintColor = UIColor.white
        
        graphView.rangeMax = Double(maxScale)
        graphView.rangeMin = Double(minScale)
        
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
        
        graphView.dataPointSpacing = CGFloat(50.0)
        graphView.shouldAdaptRange = false
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! optionsViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        var newStartingPoint = CGPoint(x: menuButton.frame.midX + 7.0  , y: menuButton.frame.midY + 36.0)
        transition.startingPoint = newStartingPoint
        transition.circleColor = menuButton.backgroundColor!
        print(menuButton.frame.maxX , menuButton.frame.maxY)
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        var newStartingPoint = CGPoint(x: menuButton.frame.midX + 7.0  , y: menuButton.frame.midY + 36.0)
        transition.startingPoint = newStartingPoint
        transition.circleColor = menuButton.backgroundColor!
        
        return transition
        
    }
    
    
    @IBAction func optionButtontapped(_ sender: Any) {
        performSegue(withIdentifier: "showOptions", sender: self)
    }
    
    @IBAction func optionbuttonTouchDown(_ sender: Any) {
        AudioServicesPlaySystemSound(1519)
    }
    
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        print("Selected Segment is \(scaleSegment.selectedSegmentIndex)")
        loadChartAnalytics()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    

}

