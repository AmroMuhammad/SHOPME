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
    @IBOutlet weak var indicatorView: UIView!
    override var isHighlighted: Bool{
        didSet{
            mainCategoryName.textColor = isHighlighted ? UIColor.black : UIColor.gray
            indicatorView.backgroundColor = isHighlighted ? UIColor.black : UIColor.white
        }
    }
    
    override var isSelected: Bool{
        didSet{
            mainCategoryName.textColor = isSelected ? UIColor.black : UIColor.gray
            indicatorView.backgroundColor = isSelected ? UIColor.black : UIColor.white

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
