//
//  ProductsCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/25/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import SDWebImage

class ProductsCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productImage: UIImageView!
    
    var productObject:CategoryProduct!{
        didSet{
            productNameLabel.text = productObject.title
            productImage.sd_setImage(with: URL(string: productObject.image.src), placeholderImage: UIImage(named: "placeholder"))
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
