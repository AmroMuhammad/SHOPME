//
//  ImageCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 05/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var productImage: UIImageView!
    
    var productImgObj: ProductImage!{
        didSet{
            productImage.sd_setImage(with: URL(string: productImgObj.src ?? ""), placeholderImage: UIImage(named: "1"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
