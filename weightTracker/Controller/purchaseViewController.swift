//
//  purchaseViewController.swift
//  weightTracker
//
//  Created by Deepak on 15/07/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import SpriteKit
import SwiftyStoreKit

class purchaseViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var purchaseButton: UIButton!
    
    var sharedSecret = "1ea73fa324054766bf5594b8d2c33e2b"
    
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
        
        if let view = backView as! SKView? {
            let scene = GameScene(size: backView.bounds.size)
            scene.scaleMode = .aspectFill
            scene.backgroundColor = UIColor(red: 28/255, green: 31/255, blue: 29/255, alpha: 1.0)
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            SwiftyStoreKit.retrieveProductsInfo(["Deepak.weightTracker.Purchase.full.version"]) { result in
                if let product = result.retrievedProducts.first {
                    let priceString = product.localizedPrice!
                    print("Product: \(product.localizedDescription), price: \(priceString)")
                    self.purchaseButton.setTitle("For only \(priceString)", for: .normal)
                }
                else if let invalidProductId = result.invalidProductIDs.first {
                    print("Invalid product identifier: \(invalidProductId)")
                }
                else {
                    print("Error: \(String(describing: result.error))")
                }
            }
        }
        
    }
    
    func purchaseProduct(){
        SwiftyStoreKit.retrieveProductsInfo(["Deepak.weightTracker.Purchase.full.version"]) { result in
            if let product = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let product):
                        // fetch content from your server, then:
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }
                        self.makeAvailabel()
                        print("Purchase Success: \(product.productId)")
                        let alert = UIAlertController(title: "Purchase Successfull", message: "Thank you for supporting us. You can select any instrument and loop.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert,animated: true, completion: nil)
                    case .error(let error):
                        
                        let alert = UIAlertController(title: "There was an error in purchase, Please try again", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                            print("Done")
                        }))
                        self.present(alert,animated: true, completion: nil)
                        
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func restorePurchase(){
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                let alert = UIAlertController(title: "Error while restoring product, Please try again", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    print("Done")
                }))
                self.present(alert,animated: true, completion: nil)
            }
            else if results.restoredPurchases.count > 0 {
                print("Product ID is : ",(results.restoredPurchases.first!.productId))
                self.makeAvailabel()
                let alert = UIAlertController(title: "Restore Successfull. Thank you for supporting us", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert,animated: true, completion: nil)
                
            }
            else {
                print("Nothing to Restore")
                let alert = UIAlertController(title: "Nothing to restore", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    print("Done")
                }))
                self.present(alert,animated: true, completion: nil)
            }
        }
    }
    
    func verifyPurchase(id : String , sharedSecret : String){
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = id
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    
    func makeAvailabel(){
        UserDefaults.standard.set(true, forKey: "purchased")
    }
    
    @IBAction func purchaseButton(_ sender: Any) {
        
    }
    
    @IBAction func restoreButton(_ sender: Any) {
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
