//
//  shopCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by marwa on 5/28/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import SDWebImage

class shopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shopImg: UIImageView!
    @IBOutlet weak var vendor: UILabel!
     

    var cellProduct : Product! {
        didSet{
         vendor.text = cellProduct.vendor
         shopImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
         shopImg.sd_setImage(with: URL(string:cellProduct.image.src) , placeholderImage: UIImage(named: "1"))
            
        }
    }
}
