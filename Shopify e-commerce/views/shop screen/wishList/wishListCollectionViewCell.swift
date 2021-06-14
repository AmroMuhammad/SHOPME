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
    var productItem : LocalProductDetails?
    var currency : String?
    override func awakeFromNib() {
        super.awakeFromNib()
       // layoutMargins = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
        productImg.layer.shadowColor = UIColor.black.cgColor
        productImg.layer.borderWidth = 1.0
        productImg.layer.borderColor = UIColor.gray.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        productImg.layer.cornerRadius = 20
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1
        productImg.layer.masksToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        currency = UserDefaults.standard.string(forKey: Constants.currencyUserDefaults)
    }
    override func layoutSubviews() {
           super.layoutSubviews()

//           contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5))
       }
    var cellProduct :LocalProductDetails! {
        didSet{
            checkImageData(imageData: cellProduct.productImageData)
            productPrice.text = cellProduct.productPrice! + " " + currency!
            productItem = cellProduct
        }
    }
    func checkImageData(imageData: Data) {
           if imageData.isEmpty {
               productImg.image = UIImage(named: "1")
           } else {
               productImg.image = UIImage(data: imageData)
           }
       }
    
    @IBAction func addToCart(_ sender: Any) {
        print("addToCart")
        delegate?.showMovingAlert(msg: Constants.addToBagFromWishMsg , product: productItem! )
    }
    
    @IBAction func deleteFromWishList(_ sender: Any) {
      print("deleteFromWishList")
        delegate?.showAlert(msg:Constants.deleteFromWishMsg , product: productItem!)
    }
    
}
