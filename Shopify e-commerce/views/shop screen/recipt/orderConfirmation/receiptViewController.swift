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
import Stripe

class receiptViewController: UITableViewController {
    var disposeBag = DisposeBag()
    var allCartProductForReceipt : [LocalProductDetails]?
    var totalCartPrice : String?
    var receiptViewModelObj : receiptViewModelType!
    var couponProductType : String?
    var currency : String?
    var address  = ""
    private var paymentTextField:STPPaymentCardTextField!
    private var activityView:UIActivityIndicatorView!
    var productCategory : [String]?
    @IBOutlet weak var payByCard: UIButton!
    @IBOutlet weak var payByCash: UIButton!
    @IBOutlet weak var shippingFee: UILabel!
    @IBOutlet weak var paymentCardView: UIView!
    @IBOutlet private weak var finalDiscount: UILabel!
    @IBOutlet private weak var receiptProductCollectionView: UICollectionView!
    @IBOutlet private weak var itemNumber: UILabel!
    @IBOutlet private weak var secondCell: UITableViewCell!
    @IBOutlet private weak var SubTotalPrice: UILabel!
    @IBOutlet private weak var totalPrice: UILabel!
    @IBOutlet private weak var discount: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var addressData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payByCash.isSelected = true
        payByCard.isSelected = false
        paymentCardView.isHidden = true
        currency = UserDefaults.standard.string(forKey: Constants.currencyUserDefaults)
        finalDiscount.text = "-0.0 " + currency!
        shippingFee.text = "25.00 " + currency!
        paymentTextField = STPPaymentCardTextField(frame: CGRect(x: 0, y: 0, width: paymentCardView.frame.width, height: paymentCardView.frame.height))
        
        activityView = UIActivityIndicatorView(style: .large)

        
        self.title = "Order Confirmation"
        secondCell.accessoryType = .disclosureIndicator
        receiptViewModelObj = receiptViewModel()
        
        paymentCardView.addSubview(paymentTextField)
        
        let receiptProductNibCell = UINib(nibName: Constants.receiptProductCell, bundle: nil)
        receiptProductCollectionView.register(receiptProductNibCell, forCellWithReuseIdentifier: Constants.receiptProductCell)
        
         receiptProductCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        receiptViewModelObj.itemNumDrive.drive(onNext: { [weak self](val) in
            self!.itemNumber.text = "\(val) items"
        }).disposed(by: disposeBag)
      
        SubTotalPrice.text = totalCartPrice! + " " + currency!
        totalPrice.text = "\(Double(totalCartPrice!)! + 25.00) " + currency!
        Observable.just(allCartProductForReceipt!).bind(to: receiptProductCollectionView.rx.items(cellIdentifier: Constants.receiptProductCell)){row,item,cell in
            (cell as? receiptProductCollectionViewCell )?.cellProduct = item
        }.disposed(by: disposeBag)
        
       
         secondCell.isUserInteractionEnabled = true
         let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(applyCouponClicked(_:)))
         secondCell.addGestureRecognizer(guestureRecognizer)
        
        receiptViewModelObj.getItemNum(products: allCartProductForReceipt!)
        
        
        receiptViewModelObj.loadingObservable.subscribe(onNext: {[weak self] (boolValue) in
            switch boolValue{
            case true:
                self?.showLoading()
            case false:
                self?.hideLoading()
            }
            }).disposed(by: disposeBag)
        
        receiptViewModelObj.errorObservable.subscribe(onNext: {[weak self] (message) in
            Support.notifyUser(title: "Error", body: message, context: self!)
        }).disposed(by: disposeBag)
        
        receiptViewModelObj.dataObservable.subscribe(onNext: {[weak self] (value) in
            if let couponType = self?.couponProductType{
                UserDefaults.standard.set(false, forKey: couponType)
            }
            LocalManagerHelper.localSharedInstance.deleteAllProductFromCart(userEmail: UserData.sharedInstance.getUserFromUserDefaults().email ?? "") { (_) in
                self?.showErrorMessage(title: "Payment Status", errorMessage: "Payment paid successfully")
            }
            }).disposed(by: disposeBag)
        receiptViewModelObj.allProductTypeDrive.drive(onNext: { [weak self](productTypeArray) in
            self?.productCategory = productTypeArray
        }).disposed(by: disposeBag)
        
        receiptViewModelObj.getAllProductType(products: allCartProductForReceipt!)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named:"home-address")
        let imageOffsetY: CGFloat = -5.0
        imageAttachment.bounds = CGRect(x: 2, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: "  " + address)
        completeText.append(textAfterIcon)
        self.addressData.textAlignment = .left
        self.addressData.attributedText = completeText

   }
    
    @IBAction func payCash(_ sender: UIButton) {
        sender.isSelected = true
        payByCard.isSelected = false
        paymentCardView.isHidden = true
    }
    
    @IBAction func payCard(_ sender: UIButton) {
       sender.isSelected = true
       payByCash.isSelected = false
        paymentCardView.isHidden = false
    }
    func showErrorMessage(title:String,errorMessage: String) {
        let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel)
        { action -> Void in
            self.navigationController?.popToRootViewController(animated: true)
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showLoading() {
        placeOrderButton.isEnabled = false
        activityView!.center = self.view.center
        self.view.addSubview(activityView!)
        activityView!.startAnimating()
    }
    
    func hideLoading() {
        placeOrderButton.isEnabled = true
        activityView!.stopAnimating()
    }
      
      @objc func applyCouponClicked(_ sender: Any) {
        let applyCouponViewController = storyboard?.instantiateViewController(identifier: Constants.applyCoupons) as! applyCouponsViewController
        applyCouponViewController.discountDelegate = self
        applyCouponViewController.productTypeArray = productCategory ?? []
          navigationController?.pushViewController(applyCouponViewController, animated: true)
      }

    @IBAction func placeOrderBtn(_ sender: Any) {
        receiptViewModelObj.fetchData(paymentTextField: paymentTextField, viewController: self,totalPrice: totalPrice.text!)
        if(payByCard.isSelected == true){
           receiptViewModelObj.fetchData(paymentTextField: paymentTextField, viewController: self)
        }else{
            if let couponType = self.couponProductType{
                UserDefaults.standard.set(false, forKey: couponType)
            }
            LocalManagerHelper.localSharedInstance.deleteAllProductFromCart(userEmail: UserData.sharedInstance.getUserFromUserDefaults().email ?? "") { (_) in
                self.showErrorMessage(title: "Payment Status", errorMessage: "Payment will be completed upon delivery")
            }
        }
    }
}

extension receiptViewController : applyCouponDelegate {
    func applyCoupon(coupone: String , productType :String) {
        self.discount.text = "-" + coupone + " " + currency!
        self.finalDiscount.text = "-" + coupone + " " + currency!
        totalPrice.text = "\(Double(totalCartPrice!)! + 25.00 - 10.00) "  + currency!
        couponProductType = productType
    }
    
}

extension receiptViewController : STPAuthenticationContext{
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

