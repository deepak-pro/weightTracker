//
//  optionsViewController.swift
//  weightTracker
//
//  Created by Deepak on 21/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import AudioToolbox
import StoreKit

class optionsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var options : [String] = ["Customize Records" ,"Rate this app" ,  "Delete All Records"]
    
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "showRecords", sender: self)
        }
        
        if indexPath.row == options.count - 1 {
            let alert = UIAlertController(title: "Are you sure you want to delete all the records", message: "This action will delete all the records you added", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert ,animated: true , completion: nil)
            AudioServicesPlaySystemSound(1521)
        }
        
        if indexPath.row == options.count - 2 {
            AudioServicesPlaySystemSound(1519)
            SKStoreReviewController.requestReview()
        }
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
