//
//  SizeCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 05/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class SizeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var sizeLabel: UILabel!
    
    var productSize: String!{
        didSet{
            sizeLabel.text = productSize
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
