//
//  receiptProductCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/10/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class receiptProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productNum: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        productNum.layer.cornerRadius = 10
        productNum.layer.masksToBounds = true
               img.layer.shadowColor = UIColor.black.cgColor
               img.layer.borderWidth = 1.0
               img.layer.borderColor = UIColor.gray.cgColor
               //productImg.layer.shadowColor = UIColor.gray.cgColor
               img.layer.cornerRadius = 20
               img.layer.shadowOffset = CGSize(width: 0, height: 0)
               img.layer.shadowRadius = 5.0
               img.layer.shadowOpacity = 1
               img.layer.masksToBounds = true
    }
   var cellProduct : LocalProductDetails! {
       didSet{
         checkImageData(imageData: cellProduct.productImageData)
         productNum.text = "\(cellProduct.quantity!)"
           
       }
   }
    func checkImageData(imageData: Data) {
        if imageData.isEmpty {
            img.image = UIImage(named: "1")
        } else {
            img.image = UIImage(data: imageData)
        }
    }
}
