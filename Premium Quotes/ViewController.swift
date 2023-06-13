//
//  ViewController.swift
//  Premium Quotes
//
//  Created by IPS-108 on 09/06/23.
//

import UIKit
import StoreKit
import SystemConfiguration

class ViewController: UIViewController, SKPaymentTransactionObserver {
    
    // Outlets for UI elements
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    @IBOutlet weak var theViewLoad: UIView!
    
    // Variables to store data
    var bookImg = String()
    var bookTitle = String()
    var bookDesc = String()
    var sellingProductID = String()
    var rentingProductsId = [String]()
    var threeMonths = String()
    var sixMonths = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the navigation bar tint color to white
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // Add yourself as a payment transaction observer
        SKPaymentQueue.default().add(self)
        
        
        // Assign values to the UI elements
        assignValues()
    }
    
    // Check if the device is connected to the internet
    func isConnectedToInternet() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    // Show an alert indicating no internet connectivity
    func showNoInternetAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Show a popup indicating that the product is already purchased
    func showPopup() {
        let alertController = UIAlertController(title: "Already Purchased", message: "You have already purchased this product.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("OK button tapped")
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Buy button action
    @IBAction func btnBuy(_ sender: UIButton) {
        if isConnectedToInternet() {
            if isPurchased(productId: sellingProductID) {
                showPopup()
            } else {
                startLoading()
                buyProducts()
            }
        } else {
            showNoInternetAlert()
        }
    }
    
    // Rent button action
    @IBAction func btnRent(_ sender: UIButton) {
        if isConnectedToInternet() {
            if isPurchased(productId: threeMonths) {
                showPopup()
            } else if isPurchased(productId: sixMonths) {
                showPopup()
            } else {
                startLoading()
                rentProducts(sender: sender)
            }
        } else {
            showNoInternetAlert()
        }
    }
    
    // Assign values to the UI elements
    func assignValues() {
        theViewLoad.isHidden = true
        loaderView.isHidden = true
        
        productImg.image = UIImage(named: bookImg)
        productTitle.text = bookTitle
        productDesc.text = bookDesc
        
        threeMonths = rentingProductsId[0]
        sixMonths = rentingProductsId[1]
    }
    
    // Initiate the purchase process
    func buyProducts() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = sellingProductID
            SKPaymentQueue.default().add(paymentRequest)
            
            print("Make payments")
        } else {
            print("Can't make payments")
        }
    }
    
    // Initiate the rental process
    func rentProducts(sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Rental Duration", message: nil, preferredStyle: .actionSheet)
        
        let threeMonthsAction = UIAlertAction(title: "3 Months", style: .default) { _ in
            self.rentProduct(productId: self.threeMonths, sourceView: sender)
        }
        
        let sixMonthsAction = UIAlertAction(title: "6 Months", style: .default) { _ in
            self.rentProduct(productId: self.sixMonths, sourceView: sender)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ _ in
            self.stopLoading()
        }
        
        
        alertController.addAction(threeMonthsAction)
        alertController.addAction(sixMonthsAction)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = sender
        alertController.popoverPresentationController?.sourceRect = sender.bounds
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Rent the product with the specified product ID
    func rentProduct(productId: String, sourceView: UIView) {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
            
            print("Make rental payments")
        } else {
            print("Can't make rental payments")
        }
    }
    
    // Check if the product with the specified product ID is purchased
    func isPurchased(productId: String) -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productId)
        
        if purchaseStatus {
            print("Already purchased")
            return true
        } else {
            print("Didn't Purchase")
            return false
        }
    }
    
    // Handle payment queue updates
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                UserDefaults.standard.set(true, forKey: transaction.payment.productIdentifier)
                
                print("Payment Success")
                stopLoading()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                print("Purchasing")
            case .failed:
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Payment Failed due to \(errorDescription)")
                }
                stopLoading() // Stop loader
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    // Start animating the loader 	
    func startLoading() {
        theViewLoad.isHidden = false
        loaderView.isHidden = false
        loaderView.startAnimating()
    }
    
    // Stop animating the loader
    func stopLoading() {
        theViewLoad.isHidden = true
        loaderView.isHidden = true
        loaderView.stopAnimating()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
}

