//
//  ProductTableViewCell.swift
//  Premium Quotes
//
//  Created by IPS-108 on 09/06/23.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
