//
//  QuoteTableViewController.swift
//  Premium Quotes
//
//  Created by IPS-108 on 08/06/23.
//
//  itpath.com.Premium-Quotes
//
//  com.itpathSolutions.InspoQuotes.PremiumQuotes

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    
    let productID = "itpath.com.PremiumQuotes.PremiumQuotes1"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        if isPurchased() {
            showPremium()
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased(){
            return quotesToShow.count + 1
        }
        else{
            return quotesToShow.count + 2
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)

        if indexPath.row < quotesToShow.count{
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.accessoryType = .none
        }
        else if indexPath.row == quotesToShow.count{
            cell.textLabel?.text = "Buy Premium quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }
        else{
            cell.textLabel?.text = "View Monthly Premium quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count  {
            buyPremium()
        }
        else if indexPath.row == quotesToShow.count + 1 {
            print("View4")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
            self.navigationController?.pushViewController(vc, animated: true)

        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func buyPremium(){
        
        if SKPaymentQueue.canMakePayments(){
            
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            
            print("make payments")
        }
        else{
            print("can't make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            if transaction.transactionState == .purchased{
                print("Payment Success")
                showPremium()
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            //lemeb77041@peogi.com
            //Hitesh1234admin
            
            else if transaction.transactionState == .failed{
                
                if let error = transaction.error{
                    let errorDescription = error.localizedDescription
                    print("Payment Failed due to \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            
            else if transaction.transactionState == .restored{
                showPremium()
                print("Transaction restored")
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func showPremium(){
        UserDefaults.standard.set(true, forKey: productID)
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool{
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchaseStatus{
            print("Already purchased")
            return true
        }
        else{
            print("Did'nt Purchased")
            return false
        }
    }

    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        //Restore Payment
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
