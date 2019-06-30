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
    
    
    @IBOutlet weak var noDataRangeLabel: UILabel!
    
    @IBOutlet weak var showDatesTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if records.count == 0{
            showDatesTableView.separatorStyle = .none
            
            let scaleImageView = UIImageView()
            let label = UILabel()
            label.text = "No data found"
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 20.0)
            scaleImageView.image = UIImage(named: "weightScale")
            
            view.addSubview(scaleImageView)
            view.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            scaleImageView.translatesAutoresizingMaskIntoConstraints = false
            
            scaleImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            scaleImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            scaleImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            scaleImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
            label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
            label.topAnchor.constraint(equalTo: scaleImageView.bottomAnchor, constant: 32).isActive = true
            
            
            
            
            print("No data in dates")
        }else {
            tableView.separatorStyle = .singleLine
        }
        
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showDatesCell", for: indexPath) as! showDatesTableViewCell
        cell.dateLabel.text = formatDate(date: records[indexPath.row].date!)
        cell.weightLabel.text = String(records[indexPath.row].weight) + " kg"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
        showDatesTableView.indicatorStyle = .white
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
