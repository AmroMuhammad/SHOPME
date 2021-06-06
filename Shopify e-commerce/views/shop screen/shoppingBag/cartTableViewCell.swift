//
//  TableViewCell.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/6/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    var delegate: TableViewCellDelegate?
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        stepperValue.text = "1"
        stepper.value = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func moveProductFromCartToWishList(_ sender: Any) {
        delegate?.showMovingAlert(msg:Constants.moveFromBagToWishMsg)
    }
    @IBAction func stepperAction(_ sender: Any) {
        let result : Int = Int((sender as! UIStepper).value)
        if(result == 0){
            delegate?.showAlert(msg: Constants.deleteFromBagMsg , completion: { [weak self](val) in
                if(val == 1){
                  self!.stepper.value = 1
                }
                 self!.stepperValue.text = "\(val)"
            })
        }
        else{
           stepperValue.text = String(result)
        }
        
    }
    
}
