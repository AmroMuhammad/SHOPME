//
//  availableCouponTableViewCell.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/11/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class availableCouponTableViewCell: UITableViewCell {

    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var discountCode: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override var isSelected: Bool {
         didSet{
            checkImg.image = isSelected ? UIImage(named: "checked") : UIImage(named: "dry-clean")
            isSelected ? print("done") : print("not done")
         }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
    }
}
