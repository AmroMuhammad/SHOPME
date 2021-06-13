//
//  NotAvailableTableViewCell.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/12/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class NotAvailableTableViewCell: UITableViewCell {

    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var discountCode: UILabel!
    @IBOutlet weak var problemMsg: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named:"exclamation-mark")
        let imageOffsetY: CGFloat = -3.0
        imageAttachment.bounds = CGRect(x: 2, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: "   You don't have a product of this type in your cart.")
        completeText.append(textAfterIcon)
        self.problemMsg.textAlignment = .left
        self.problemMsg.attributedText = completeText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
    }
    
}
