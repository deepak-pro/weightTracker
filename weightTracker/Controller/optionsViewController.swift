//
//  optionsViewController.swift
//  weightTracker
//
//  Created by Deepak on 21/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit

class optionsViewController: UIViewController {

    
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
