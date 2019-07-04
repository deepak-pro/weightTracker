//
//  exportDataViewController.swift
//  weightTracker
//
//  Created by Deepak on 04/07/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit

class exportDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exportButtonTapped(_ sender: Any) {
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
