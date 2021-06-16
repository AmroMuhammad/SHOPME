//
//  SingleOrderTableViewCell.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/16/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class SingleOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageContainerView.layer.cornerRadius = 15
        imageContainerView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
