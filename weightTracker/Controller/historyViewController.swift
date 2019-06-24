//
//  historyViewController.swift
//  weightTracker
//
//  Created by Deepak on 24/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit

class historyViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var historyTablleView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! historyTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        historyTablleView.indicatorStyle = .white
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backSwipe(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
