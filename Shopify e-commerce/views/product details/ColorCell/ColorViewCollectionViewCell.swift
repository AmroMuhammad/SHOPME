//
//  ColorViewCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 02/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class ColorViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
                
        self.lbl.layer.cornerRadius = 34.0
        self.lbl.layer.masksToBounds = true
        self.lbl.layer.borderWidth = 3
        self.lbl.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.layer.masksToBounds = false
    }
        
//
    

}
