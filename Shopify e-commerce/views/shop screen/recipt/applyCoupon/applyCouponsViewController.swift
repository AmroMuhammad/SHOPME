//
//  applyCouponsViewController.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/11/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class applyCouponsViewController: UIViewController {
    var disposeBag = DisposeBag()
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var indicatorView = UIView()
    let indicatorHeight : CGFloat = 5
    var selectedIndex = 0
    var discountDelegate : applyCouponDelegate?
    
    var applyCouponViewModelObj: applyCouponViewModel?
    var productTypeArray = ["Women","Kids"]
    @IBOutlet weak var emptyMsg: UILabel!
    @IBOutlet weak var availableEmptyMsg: UILabel!
    @IBOutlet weak var availableEmptyImg: UIImageView!
    @IBOutlet weak var emptyImg: UIImageView!
    @IBOutlet weak var notAvailableCouponView: UIView!
    @IBOutlet weak var notAvailableTableView: UITableView!
    @IBOutlet weak var availableCouponView: UIView!
    @IBOutlet weak var availableCoupon: UITableView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var chooseCouponLabel: UILabel!
    @IBOutlet weak var couponStateCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notAvailableNibCell = UINib(nibName: Constants.NotAvailableCell, bundle: nil)
        notAvailableTableView.register( notAvailableNibCell, forCellReuseIdentifier: Constants.NotAvailableCell)
        
        applyCouponViewModelObj = applyCouponViewModel()
        availableCoupon.delegate = self
        notAvailableTableView.delegate = self
        couponStateCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        // availableCoupon.rx.setDelegate(self).disposed(by: disposeBag)
       //  notAvailableTableView.rx.setDelegate(self).disposed(by: disposeBag)
        couponStateCollectionView.delegate = self
        Observable.just(["Available","Not Available"]).bind(to: couponStateCollectionView.rx.items(cellIdentifier: Constants.couponsStateCell)){row,item,cell in
            (cell as? couponsStateCollectionViewCell )?.lbl.text = item
        }.disposed(by: disposeBag)
        
        applyCouponViewModelObj?.noFindItemsNotAvailableDriver.drive(onNext: { (val) in
            if(val){
                print("not available empty")
                self.emptyImg.isHidden = false
                self.emptyMsg.isHidden = false
            }
        }).disposed(by: disposeBag)
        
        applyCouponViewModelObj?.noFindItemsAvailableDriver.drive(onNext: { (val) in
            if(val){
                print("available empty")
                self.availableEmptyMsg.isHidden = false
                self.availableEmptyImg.isHidden = false
                self.alertLabel.isHidden = true
                self.chooseCouponLabel.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        applyCouponViewModelObj?.notAvailableCouponsDrive.drive(onNext: {[weak self] (val) in

            self?.emptyImg.isHidden = true
            self?.emptyMsg.isHidden = true
            Observable.just(val).bind(to: self!.notAvailableTableView.rx.items(cellIdentifier: Constants.NotAvailableCell)){row,item,cell in
                  (cell as? NotAvailableTableViewCell )?.discountCode.text = "Code: " + item.code!
                (cell as? NotAvailableTableViewCell )?.productType.text = ". For " + item.productType! + " products"
             }.disposed(by: self!.disposeBag)
      }).disposed(by: disposeBag)
        
        couponStateCollectionView.rx.itemSelected.subscribe{[weak self](IndexPath) in
            if( IndexPath.element![1] == 0){
                self!.availableCouponView.isHidden = false
                self!.notAvailableCouponView.isHidden = true
            }else{
               self!.availableCouponView.isHidden = true
               self!.notAvailableCouponView.isHidden = false
            }
        }.disposed(by: disposeBag)
       
        couponStateCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
        indicatorView.backgroundColor = .black
        indicatorView.frame = CGRect(x: couponStateCollectionView.bounds.minX, y: couponStateCollectionView.bounds.maxY - indicatorHeight, width: couponStateCollectionView.bounds.width / CGFloat(2), height: indicatorHeight)
        couponStateCollectionView.addSubview(indicatorView)
        
       couponStateCollectionView.rx.itemSelected.subscribe{[weak self](IndexPath) in
           self!.selectedIndex = IndexPath.element![1]
           self!.changeIndecatorViewPosition()
        }.disposed(by: disposeBag)
        
        availableCoupon.rx.itemSelected.subscribe{[weak self](IndexPath) in
                //  self!.selectedIndex = IndexPath.element![1]
            let cell = self?.availableCoupon.cellForRow(at: IndexPath.element!) as? availableCouponTableViewCell
            cell?.isSelected = true
            self!.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
          
        availableCoupon.rx.modelSelected(Coupon.self).subscribe{[weak self](item) in
            self!.discountDelegate?.applyCoupon(coupone: "10.00" , productType : (item.element?.productType)!)
        }.disposed(by: disposeBag)
       
        applyCouponViewModelObj?.availableCouponsDrive.drive(onNext: {[weak self] (val) in
            self?.availableEmptyMsg.isHidden = true
            self?.availableEmptyImg.isHidden = true
            self?.alertLabel.isHidden = false
            self?.chooseCouponLabel.isHidden = false

            Observable.just(val).bind(to: self!.availableCoupon.rx.items(cellIdentifier: Constants.availableCouponCell)){row,item,cell in
                (cell as? availableCouponTableViewCell )?.discountCode.text = "Code: " + item.code!
                (cell as? availableCouponTableViewCell )?.productType.text = ". For " + item.productType! + " products"
            }.disposed(by: self!.disposeBag)
        //}
        }).disposed(by: disposeBag)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named:"alert")
        let imageOffsetY: CGFloat = -3.0
        imageAttachment.bounds = CGRect(x: 20, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: "          Only one coupon can be used per order.")
        completeText.append(textAfterIcon)
        self.alertLabel.textAlignment = .left
        self.alertLabel.attributedText = completeText
        
        applyCouponViewModelObj!.getAvailableAndUnavailableCoupons(productType: productTypeArray)
               
    }
    
    func changeIndecatorViewPosition(){
        let desiredX = (couponStateCollectionView.bounds.width / CGFloat(2)) * CGFloat(selectedIndex)
        UIView.animate(withDuration: 0.3) {
             self.indicatorView.frame = CGRect(x: desiredX, y: self.couponStateCollectionView.bounds.maxY - self.indicatorHeight, width: self.couponStateCollectionView.frame.width / CGFloat(2), height: self.indicatorHeight)
        }
    }

}
extension applyCouponsViewController :  UICollectionViewDelegateFlowLayout {

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
           return CGSize(width: (self.couponStateCollectionView.frame.width)/2, height: 30)
        }

}
extension applyCouponsViewController:   UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }
    
}
