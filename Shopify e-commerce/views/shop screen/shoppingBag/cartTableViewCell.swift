//
//  TableViewCell.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/6/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import SDWebImage
class TableViewCell: UITableViewCell {
    var delegate: TableViewCellDelegate?
    var productItem : LocalProductDetails?
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       // layoutMargins = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
        
       
        productImg.layer.shadowColor = UIColor.black.cgColor
        productImg.layer.borderWidth = 1.0
        productImg.layer.borderColor = UIColor.gray.cgColor
        //productImg.layer.shadowColor = UIColor.gray.cgColor
        productImg.layer.cornerRadius = 20
        productImg.layer.shadowOffset = CGSize(width: 0, height: 0)
        productImg.layer.shadowRadius = 5.0
        productImg.layer.shadowOpacity = 1
        productImg.layer.masksToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    var cellCartProduct : LocalProductDetails! {
            didSet{
                productPrice.text = cellCartProduct.productPrice
                productName.text = cellCartProduct.title
                stepperValue.text = "\(cellCartProduct.quantity ?? 1)"
                checkImageData(imageData: cellCartProduct.productImageData)
                productItem = cellCartProduct
                stepper.value = Double(cellCartProduct.quantity ?? 1)
                
            }
        }
    func checkImageData(imageData: Data) {
        if imageData.isEmpty {
            productImg.image = UIImage(named: "1")
        } else {
            productImg.image = UIImage(data: imageData)
        }
    }
    @IBAction func moveProductFromCartToWishList(_ sender: Any) {
        delegate?.showMovingAlert(msg:Constants.moveFromBagToWishMsg , product: productItem!)
    }
    @IBAction func stepperAction(_ sender: Any) {
        let result : Int = Int((sender as! UIStepper).value)
        if(result == 0){
            delegate?.showAlert(msg: Constants.deleteFromBagMsg ,  product: productItem! , completion: { [weak self](val) in
                if(val == 1){
                  self!.stepper.value = 1
                }
                 self!.stepperValue.text = "\(val)"
            })
        }
        else{
            if result <= productItem?.inventory_quantity ?? 0 {
                productItem?.quantity = result
                delegate?.updateCoreDate(product : productItem!)
                stepperValue.text = String(result)
            } else {
                delegate?.showAlert(msg: "Sorry, this quantity in NOT in the inventory quantity :(", product: productItem!, completion: { [weak self] (val) in
                    (sender as! UIStepper).value -= 1.0
                    self!.stepperValue.text = "\(result-1)"
                })
            }
        }
        
    }
    
}
