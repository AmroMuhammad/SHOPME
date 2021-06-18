//
//  SizeCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 06/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class SizeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var sizeLabel: UILabel!
    
    var productSize: String!{
        didSet{
            sizeLabel.text = productSize
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.sizeLabel.layer.cornerRadius = 15.0
        self.sizeLabel.layer.masksToBounds = true
//        unselectCell()
        self.layer.masksToBounds = false
        sizeLabel.sizeToFit()
//        sizeLabel.minimumScaleFactor = 0.5
    }
    
//    override var isHighlighted: Bool{
//        didSet{
//            self.sizeLabel.layer.borderWidth = isHighlighted ? 3.0 : 0.0
//            self.sizeLabel.layer.borderColor = isHighlighted ? UIColor.red.cgColor : UIColor.gray.cgColor
//        }
//    }
    
    override var isSelected: Bool{
        didSet{
            self.sizeLabel.layer.borderWidth = isSelected ? 2.0 : 0.0
            self.sizeLabel.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.gray.cgColor

        }
    }
    
//    func selectedCell() {
//        self.sizeLabel.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
//        self.sizeLabel.layer.borderWidth = 3.5
//    }
//
//    func unselectCell() {
//        self.sizeLabel.layer.borderWidth = 3
//        self.sizeLabel.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//    }
    
}
