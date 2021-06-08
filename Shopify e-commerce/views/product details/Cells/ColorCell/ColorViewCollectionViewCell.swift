//
//  ColorViewCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 02/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class ColorViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var lbl: UILabel!
    
    var productColor: UIColor!{
        didSet{
            lbl.backgroundColor = productColor
        }
    }

    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
                
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 1.0
        
        self.lbl.layer.cornerRadius = 15
        self.lbl.layer.masksToBounds = true
//        self.lbl.layer.borderWidth = 2
//        self.lbl.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.layer.masksToBounds = false
    }
        
    override var isSelected: Bool{
        didSet{
            self.layer.borderWidth = isSelected ? 2.0 : 0.0
            self.layer.borderColor = isSelected ? UIColor.red.cgColor : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
//
//    func selectedCell() {
//        self.lbl.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
//        self.lbl.layer.borderWidth = 3.5
//    }
//
//    func unselectCell() {
//        self.lbl.layer.borderWidth = 3
//        self.lbl.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//    }

}
