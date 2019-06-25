//
//  selectDatesViewController.swift
//  weightTracker
//
//  Created by Deepak on 25/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit

class selectDatesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
