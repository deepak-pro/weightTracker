//
//  historyViewController.swift
//  weightTracker
//
//  Created by Deepak on 24/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import RealmSwift

class historyViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
    
    var records = [Record]()
    let realm = try! Realm()
    
    @IBOutlet weak var historyTablleView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! historyTableViewCell
        cell.dateLabel.text = formatDate(date: records[indexPath.row].date!)
        cell.weightLabel.text = String(records[indexPath.row].weight) + " kg"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func formatDate(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM  dd,  yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func fetchData(){
        let results = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: false)
        for i in results {
            let newRecord = Record()
            newRecord.date = i.date
            newRecord.id = i.id
            newRecord.weight = i.weight
            records.append(newRecord)
        }
        historyTablleView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        historyTablleView.indicatorStyle = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backSwipe(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
