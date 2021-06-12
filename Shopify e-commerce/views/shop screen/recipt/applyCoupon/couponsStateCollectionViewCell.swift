//
//  couponsStateCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/11/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class couponsStateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl: UILabel!
     override func awakeFromNib() {
           super.awakeFromNib()
               lbl.alpha = 0.6
           }
    
       override var isSelected: Bool {
           didSet{
              lbl.alpha = isSelected ? 1.0 : 0.6
           }
      }


}
