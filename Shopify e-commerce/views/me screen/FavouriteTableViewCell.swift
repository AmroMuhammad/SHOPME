//
//  FavouriteTableViewCell.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/20/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var favLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
    }

}
