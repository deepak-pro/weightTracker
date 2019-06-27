//
//  showDatesViewController.swift
//  weightTracker
//
//  Created by Deepak on 27/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import RealmSwift

class showDatesViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    let realm = try! Realm()
    var records = [Record]()
    
    @IBOutlet weak var showDatesTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showDatesCell", for: indexPath) as! showDatesTableViewCell
        cell.dateLabel.text = formatDate(date: records[indexPath.row].date!)
        cell.weightLabel.text = String(records[indexPath.row].weight)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func fetchData(){
        
        
        endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate!)
        print("Start date is \(startDate!)")
        print("End date is \(endDate!)")
        
        let results = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: false).filter("date BETWEEN {%@, %@}", startDate , endDate)
        for i in results {
            let newRecord = Record()
            newRecord.date = i.date
            newRecord.id = i.id
            newRecord.weight = i.weight
            records.append(newRecord)
        }
        showDatesTableView.reloadData()
        
    }
    
    func formatDate(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM  dd,  yyyy"
        let result = formatter.string(from: date)
        return result
    }

    @IBOutlet weak var datesTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datesTitle.text = String("\(formatDate(date: startDate!)) - \(formatDate(date: endDate!))")
        fetchData()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipeBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    


}
