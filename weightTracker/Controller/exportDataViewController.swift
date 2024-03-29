//
//  exportDataViewController.swift
//  weightTracker
//
//  Created by Deepak on 04/07/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD
import WebKit


class exportDataViewController: UIViewController {
    
    var records = [Record]()
    let realm = try! Realm()
    var finalHtml = ""
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        records.removeAll()
        finalHtml = ""
        SVProgressHUD.show()
        fetchData()
        createHtml()
        loadWebView()
    }
    
    func loadWebView(){
        webView.loadHTMLString(finalHtml, baseURL: nil)
        SVProgressHUD.dismiss()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createHtml(){
        let firstHtml = """
        <!DOCTYPE html>
        <html>
        <head>
        <title>Report</title>
        <style type="text/css">
        #container {
            margin: 80px 80px 80px 80px ;
        }
        table {
            margin: 10px 10px 10px 10px ;
        }
        td {
            text-align: center;
        }
        </style>
        </head>
        <body><font size="8">
        <div id="container">
        <h2>Weight Loss Report</h2>
        <center>
        <table border="1" width="700px">
        <tr>
        <td>Sno.</td>
        <td>Date</td>
        <td>Weight</td>
        </tr>
        """
        var middleHtml = ""
        
        let endHtml = """
        </table>
        </table>
        </center>
        </div>
        </body>
        </html>
        """
        var count = 1
        for record in records {
            middleHtml = middleHtml + "<tr><td>\(count)</td><td>\(formatDate(date: record.date!))</td><td>\(record.weight) kg</td></tr>"
            count = count + 1
        }
        
        finalHtml = firstHtml + middleHtml + endHtml
    }
    
    @IBAction func exportButtonTapped(_ sender: Any) {
    
//        let messageView = UIView()
//        messageView.backgroundColor = UIColor.darkGray
//        messageView.layer.cornerRadius = CGFloat(10.0)
//        messageView.clipsToBounds = true
//        self.view.addSubview(messageView)
//        messageView.translatesAutoresizingMaskIntoConstraints = false
//        messageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        messageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        messageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
//        messageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
//        messageView.heightAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
//
//        let label = UILabel()
//        label.text = "Creating PDF..."
//        label.textColor = UIColor.white
//        label.textAlignment = .center
//        messageView.addSubview(label)
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.centerXAnchor.constraint(equalTo: messageView.centerXAnchor).isActive = true
//        label.centerYAnchor.constraint(equalTo: messageView.centerYAnchor).isActive = true
//        label.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 10).isActive = true
//        label.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -10).isActive = true
//        label.heightAnchor.constraint(equalToConstant: CGFloat(40)).isActive = true
        
        self.saveHtmlToPdf(htmlString: self.finalHtml, witName: "output")
        
        
        
        
    }
    
    func formatDate(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM  dd,  yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func saveHtmlToPdf(htmlString : String , witName outputName: String) {
        
        let html = htmlString
        let formatter = UIMarkupTextPrintFormatter(markupText: html)
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(formatter, startingAtPageAt: 0)
        
        let page = CGRect(x: 0, y: 0, width: 592.2, height: 841.8)
        render.setValue(page, forKey: "paperRect")
        render.setValue(page, forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        
        for i in 0..<render.numberOfPages{
            UIGraphicsBeginPDFPage()
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Weight Loss Report").appendingPathExtension("pdf")
            else { fatalError("Destination URL not created")
        }
        
        print("Path is \(outputURL)")
        pdfData.write(to: outputURL, atomically: true)
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [outputURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView=self.view
        self.present(activityViewController, animated: true, completion: nil)
        
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
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
