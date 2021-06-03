//
//  colorCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 26/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var colorCircleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) { //Your code should go here.
        super.draw(rect)
//        self.layer.cornerRadius = self.frame.width / 6
        
        self.layer.cornerRadius = 300
        self.layer.masksToBounds = true
    
//        colorCircleView.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//        colorCircleView.layer.borderWidth = 1
//        colorCircleView.layer.cornerRadius = min(colorCircleView.frame.size.height, colorCircleView.frame.size.width) * 2.5
//        colorCircleView.layer.masksToBounds = true
    }
    

}
