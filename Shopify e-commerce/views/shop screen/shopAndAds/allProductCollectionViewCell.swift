//
//  allProductCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by marwa on 5/28/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class allProductCollectionViewCell: UICollectionViewCell {
    
   
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
           categoryName.alpha = 0.6
       }
       
       func setupCell(text: String) {
          categoryName.text = text
       }
       
       override var isSelected: Bool {
           didSet{
               categoryName.alpha = isSelected ? 1.0 : 0.6
           }
       }
}
