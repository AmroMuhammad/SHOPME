//
//  receiptViewController.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/10/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class receiptViewController: UITableViewController {
    var disposeBag = DisposeBag()
    var allCartProductForReceipt : [CartProduct]?
    var totalCartPrice : String?
    var receiptViewModelObj : receiptViewModelType!
   
    
    @IBOutlet weak var finalDiscount: UILabel!
    @IBOutlet weak var receiptProductCollectionView: UICollectionView!
    @IBOutlet weak var itemNumber: UILabel!
    @IBOutlet weak var secondCell: UITableViewCell!
    @IBOutlet weak var SubTotalPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var discount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Order Confirmation"
        secondCell.accessoryType = .disclosureIndicator
        receiptViewModelObj = receiptViewModel()
        
        let receiptProductNibCell = UINib(nibName: Constants.receiptProductCell, bundle: nil)
        receiptProductCollectionView.register(receiptProductNibCell, forCellWithReuseIdentifier: Constants.receiptProductCell)
        
         receiptProductCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        receiptViewModelObj.itemNumDrive.drive(onNext: { [weak self](val) in
            self!.itemNumber.text = "\(val) items"
        }).disposed(by: disposeBag)
      
        SubTotalPrice.text = "US$"+totalCartPrice!
        totalPrice.text = "US$\(Double(totalCartPrice!)! + 25.00)"
        Observable.just(allCartProductForReceipt!).bind(to: receiptProductCollectionView.rx.items(cellIdentifier: Constants.receiptProductCell)){row,item,cell in
            (cell as? receiptProductCollectionViewCell )?.cellProduct = item
        }.disposed(by: disposeBag)
        
       
         secondCell.isUserInteractionEnabled = true
         let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(applyCouponClicked(_:)))
         secondCell.addGestureRecognizer(guestureRecognizer)
        
        receiptViewModelObj.getItemNum(products: allCartProductForReceipt!)

   }
      
      @objc func applyCouponClicked(_ sender: Any) {
        let applyCouponViewController = storyboard?.instantiateViewController(identifier: Constants.applyCoupons) as! applyCouponsViewController
        applyCouponViewController.discountDelegate = self
          navigationController?.pushViewController(applyCouponViewController, animated: true)
      }

    @IBAction func placeOrderBtn(_ sender: Any) {
        
    }
}

extension receiptViewController : applyCouponDelegate {
    func applyCoupon(coupone: String) {
        self.discount.text = coupone
        self.finalDiscount.text = coupone
        totalPrice.text = "US$\(Double(totalCartPrice!)! + 25.00 - 10.00)"
    }
    
}
