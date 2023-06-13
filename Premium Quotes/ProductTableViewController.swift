//
//  ProductTableViewController.swift
//  Premium Quotes
//
//  Created by IPS-108 on 09/06/23.
//

import UIKit

class ProductTableViewController: UITableViewController {
    
    // Arrays to store the data for each book
    let booksImg = ["book1","book2","book3","book4","book5"]
    let bookTitle = ["To Kill a Mockingbird","Nineteen Eighty-Four","The Great Gatsby","The Hobbit","The Alchemist"]
    let bookDesc = ["To Kill a Mockingbird is a novel by the American author Harper Lee. It was published in 1960 and was instantly successful. In the United States, it is widely read in high schools and middle schools.","Nineteen Eighty-Four is a dystopian social science fiction novel and cautionary tale by English writer George Orwell. It was published on 8 June 1949 by Secker & Warburg as Orwell's ninth and final book completed in his lifetime.","The Great Gatsby is a 1925 novel by American writer F. Scott Fitzgerald. Set in the Jazz Age on Long Island, near New York City, the novel depicts first-person narrator Nick Carraway's interactions with mysterious millionaire Jay Gatsby and Gatsby's obsession to reunite with his former lover, Daisy Buchanan.","The Hobbit, or There and Back Again is a children's fantasy novel by English author J. R. R. Tolkien. It was published in 1937 to wide critical acclaim, being nominated for the Carnegie Medal and awarded a prize from the New York Herald Tribune for best juvenile fiction.","The Alchemist is a novel by Brazilian author Paulo Coelho which was first published in 1988. Originally written in Portuguese, it became a widely translated international bestseller."]
    
    // Array to store the product IDs for selling
    let sellingProductsId = [
        "itpath.in.PremiumQuotes.ToKillMockingbird", //lemeb77041@peogi.com
        "itpath.in.PremiumQuotes.NineteenEightyFour",
        "itpath.in.PremiumQuotes.TheGreatGatsby",
        "itpath.in.PremiumQuotes.TheHobbit",
        "itpath.in.PremiumQuotes.TheAlchemist"
    ]
    
    // Array to store the product IDs for renting
    let rentingProductsId = [
        ["itpath.com.rent.threeMonths.ToKillaMockingbird","itpath.com.rent.sixMonths.ToKillaMockingbird"],
        ["itpath.com.rent.threeMonths.NineteenEightyFour","itpath.com.rent.sixMonths.NineteenEightyFour"],
        ["itpath.com.rent.threeMonths.TheGreatGatsby","itpath.com.rent.sixMonths.TheGreatGatsby"],
        ["itpath.com.rent.threeMonths.TheHobbit","itpath.com.rent.sixMonths.TheHobbit"],
        ["itpath.com.rent.threeMonth.TheAlchemist","itpath.com.rent.sixMonths.TheAlchemist"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set navigation bar title text color to white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the table view
        return booksImg.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell and set the data for the corresponding book
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductTableViewCell
        
        cell?.productImg.image = UIImage(named: booksImg[indexPath.row])
        cell?.productTitle.text = bookTitle[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle the selection of a row
        
        // Instantiate the view controller for product details
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        // Get the data for the selected book
        let productImg = booksImg[indexPath.row]
        let productTitle = bookTitle[indexPath.row]
        let productDesc = bookDesc[indexPath.row]
        
        // Pass the data to the view controller
        vc.bookImg = productImg
        vc.bookTitle = productTitle
        vc.bookDesc = productDesc
        
        vc.sellingProductID = sellingProductsId[indexPath.row]
        vc.rentingProductsId = rentingProductsId[indexPath.row]
        
        // Push the view controller onto the navigation stack
        self.navigationController?.pushViewController(vc, animated: true)
        
        // Deselect the row after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
