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
    
    override func layoutSubviews() {
           super.layoutSubviews()

           contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5))
       }
    var cellProduct : Product! {
        didSet{
//         vendor.text = cellProduct.vendor
//         shopImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
//         shopImg.sd_setImage(with: URL(string:cellProduct.image.src) , placeholderImage: UIImage(named: "1"))
            
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        print("addToCart")
        delegate?.showMovingAlert(msg: Constants.addToBagFromWishMsg)
    }
    
    @IBAction func deleteFromWishList(_ sender: Any) {
      print("deleteFromWishList")
        delegate?.showAlert(msg:Constants.deleteFromWishMsg )
    }
    
}
