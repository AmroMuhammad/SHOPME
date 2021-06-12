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
    
    @IBOutlet weak var availableCoupon: UITableView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var couponStateCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyCouponViewModelObj = applyCouponViewModel()
        availableCoupon.delegate = self
        couponStateCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        couponStateCollectionView.delegate = self
        Observable.just(["Available","Not Available"]).bind(to: couponStateCollectionView.rx.items(cellIdentifier: Constants.couponsStateCell)){row,item,cell in
            (cell as? couponsStateCollectionViewCell )?.lbl.text = item
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
            self!.discountDelegate?.applyCoupon(coupone: "-US$10.00")
            self!.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
       
        applyCouponViewModelObj?.availableCouponsDrive.drive(onNext: {[weak self] (val) in
            Observable.just(val).bind(to: self!.availableCoupon.rx.items(cellIdentifier: Constants.availableCouponCell)){row,item,cell in
                (cell as? availableCouponTableViewCell )?.discountCode.text = "Code: " + item.code!
                (cell as? availableCouponTableViewCell )?.productType.text = item.productType
            }.disposed(by: self!.disposeBag)
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
        
        applyCouponViewModelObj!.getAvailableAndUnavailableCoupons(productType: ["Women","Kids","Men"])
               
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
