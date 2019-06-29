//
//  introViewController.swift
//  weightTracker
//
//  Created by Deepak on 29/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import paper_onboarding
import AudioToolbox

class introViewController: UIViewController , PaperOnboardingDataSource {
    
    @IBOutlet weak var onboardVIew: OnboardingView!
    
    var current : Int = 0
    var timer : Timer = Timer()
    var buttonG = UIButton()
    var swipeLabel = UILabel()
    var swipeImage = UIImageView()
    var buttonCreated = false
    var swipeCreated = false
    
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let backgroundColorOne = UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 1)
        let backgroundColorTwo = UIColor(displayP3Red: 46/255, green: 134/255, blue: 206/255, alpha: 1.0)
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descirptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        return [
            OnboardingItemInfo(informationImage: UIImage(named: "logo")!,
                               title: "Instrumental",
                               description: "A Drumpad for music instruments. Swipe for next",
                               pageIcon: UIImage(named: "nothing")!,
                               color: backgroundColorOne,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descirptionFont),
            
            OnboardingItemInfo(informationImage: UIImage(named: "logo")!,
                               title: "Instruments and Loops",
                               description: "Select instrument of your choice and play the tune you want.",
                               pageIcon: UIImage(named: "nothing")!,
                               color: backgroundColorTwo,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descirptionFont),
            
            OnboardingItemInfo(informationImage: UIImage(named: "logo")!,
                               title: "Tap On Tiles to Play",
                               description: "Total of Eight tiles on drumpad for different notes.",
                               pageIcon: UIImage(named: "nothing")!,
                               color: backgroundColorOne,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descirptionFont),
            ][index]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        onboardVIew.dataSource = self
    }
    
    func createSwipeRight(){
        swipeCreated = true
        
        swipeLabel.text = "Swipe"
        swipeLabel.backgroundColor = UIColor.clear
        let labelFont = UIFont(name: "AvenirNext-Regular", size: 20)!
        swipeLabel.font = labelFont
        swipeLabel.textAlignment = .center
        swipeLabel.textColor = UIColor.white
        
        swipeImage.image = UIImage(named: "swipeRight")!
        swipeImage.contentMode = .scaleAspectFill
        
        onboardVIew.addSubview(swipeLabel)
        onboardVIew.addSubview(swipeImage)
        
        swipeLabel.translatesAutoresizingMaskIntoConstraints = false
        swipeImage.translatesAutoresizingMaskIntoConstraints = false
        
        swipeLabel.centerXAnchor.constraint(equalTo: onboardVIew.centerXAnchor).isActive = true
        swipeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        swipeLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        swipeLabel.bottomAnchor.constraint(equalTo: onboardVIew.bottomAnchor, constant: -120).isActive = true
        
        swipeImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        swipeImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        swipeImage.leadingAnchor.constraint(equalTo: swipeLabel.trailingAnchor, constant: 16).isActive = true
        
        swipeImage.centerYAnchor.constraint(equalTo: swipeLabel.centerYAnchor).isActive = true
        
    }
    
    func createButton(){
        buttonCreated = true
        buttonG = UIButton()
        buttonG.setTitle("Get Started".uppercased(), for: .normal)
        buttonG.setTitleColor(UIColor.white, for: .normal)
        buttonG.backgroundColor = UIColor(displayP3Red: 46/255, green: 134/255, blue: 206/255, alpha: 1.0)
        buttonG.layer.cornerRadius = CGFloat(25.0)
        buttonG.clipsToBounds = true
        let buttonFont = UIFont(name: "AvenirNext-Bold", size: 18)!
        buttonG.titleLabel?.font = buttonFont
        buttonG.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
        onboardVIew.addSubview(buttonG)
        
        buttonG.translatesAutoresizingMaskIntoConstraints = false
        buttonG.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonG.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonG.bottomAnchor.constraint(equalTo: onboardVIew.bottomAnchor, constant: -100).isActive = true
        buttonG.centerXAnchor.constraint(equalTo: onboardVIew.centerXAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){_ in
            if(self.onboardVIew.currentIndex != self.current){
                AudioServicesPlaySystemSound(1519)
            }
            self.current = self.onboardVIew.currentIndex
            
            if self.onboardVIew.currentIndex == 0 {
                UIView.animate(withDuration: 0.2, animations: {
                    if !self.swipeCreated{
                        self.createSwipeRight()
                    }
                })
            }else {
                self.swipeCreated = false
                self.swipeLabel.removeFromSuperview()
                self.swipeImage.removeFromSuperview()
            }
            
            
            if self.onboardVIew.currentIndex == 2 {
                UserDefaults.standard.set("onBoardingDone", forKey: "onBoard")
                UIView.animate(withDuration: 0.2, animations: {
                    if !self.buttonCreated{
                        self.createButton()
                    }
                    
                })
            }
            else {
                self.buttonCreated = false
                self.buttonG.removeFromSuperview()
            }
        }
    }
    
    @objc func getStarted(){
        print("Going to main")
        performSegue(withIdentifier: "showMain", sender: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    


}
