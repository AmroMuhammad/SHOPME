//
//  SubCategoryCollectionViewCell.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/25/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class SubCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainCategoryName: UILabel!
    override var isHighlighted: Bool{
        didSet{
            mainCategoryName.textColor = isHighlighted ? UIColor.black : UIColor.gray
            mainCategoryName.backgroundColor = isHighlighted ? UIColor(named: "selectedBackground") : UIColor(named: "backgroundColor")
        }
    }
    
    override var isSelected: Bool{
        didSet{
            mainCategoryName.textColor = isSelected ? UIColor.black : UIColor.gray
            mainCategoryName.backgroundColor = isSelected ? UIColor(named: "selectedBackground") : UIColor(named: "backgroundColor")

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
