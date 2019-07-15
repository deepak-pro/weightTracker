//
//  purchaseViewController.swift
//  weightTracker
//
//  Created by Deepak on 15/07/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit

class purchaseViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
    
    var images = [UIImage(named: "icon"),UIImage(named: "pdf"),UIImage(named: "calenderIcon")]
    var titles = ["Add unlimited records","Export report as PDF","Set previous data"]
    var subtitiles = ["Track your weight over long period of time","Send PDF reports of weight to anyone","Set weight data later if you forgot"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell", for: indexPath) as! purchaseTableViewCell
        cell.cellImage.image = images[indexPath.row]
        cell.cellTitle.text = titles[indexPath.row]
        cell.cellSubtitle.text = subtitiles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
