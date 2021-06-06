//
//  wishListCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/5/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class wishListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    var delegate: CollectionViewCellDelegate?
    var cellProduct : Product! {
        didSet{
//         vendor.text = cellProduct.vendor
//         shopImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
//         shopImg.sd_setImage(with: URL(string:cellProduct.image.src) , placeholderImage: UIImage(named: "1"))
            
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        print("addToCart")
        delegate?.showAlert(msg: Constants.addToBagFromWishMsg)
    }
    
    @IBAction func deleteFromWishList(_ sender: Any) {
      print("deleteFromWishList")
        delegate?.showAlert(msg:Constants.deleteFromWishMsg )
    }
    
}
