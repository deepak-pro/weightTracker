//
//  optionsViewController.swift
//  weightTracker
//
//  Created by Deepak on 21/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import AudioToolbox

class optionsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var options : [String] = ["Customize Records" , "Delete All Records"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! optionsTableViewCell
        cell.textlabel.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissTouchDown(_ sender: Any) {
        AudioServicesPlaySystemSound(1519)
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
