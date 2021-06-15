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
import Lottie

class applyCouponsViewController: UIViewController {
    var disposeBag = DisposeBag()
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var indicatorView = UIView()
    let indicatorHeight : CGFloat = 5
    var selectedIndex = 0
    var discountDelegate : applyCouponDelegate?
    var NoavailableEmpty : Bool = false
    var availableEmpty : Bool = false
    
    var applyCouponViewModelObj: applyCouponViewModel?
    var productTypeArray = ["Women","Kids"]
    @IBOutlet weak var animationImgView: UIView!
    @IBOutlet weak var notAvailableCouponView: UIView!
    @IBOutlet weak var notAvailableTableView: UITableView!
    @IBOutlet weak var availableCouponView: UIView!
    @IBOutlet weak var availableCoupon: UITableView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var chooseCouponLabel: UILabel!
    @IBOutlet weak var couponStateCollectionView: UICollectionView!
    
    lazy var backgroundAnimationView: AnimationView = {
        let animationView = AnimationView()
        animationImgView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: animationImgView.topAnchor).isActive = true
        animationView.rightAnchor.constraint(equalTo: animationImgView.rightAnchor).isActive = true
        animationView.leftAnchor.constraint(equalTo: animationImgView.leftAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: animationImgView.bottomAnchor).isActive = true
        
        return animationView
    }()
    
    
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
                self.NoavailableEmpty = true
                print("not available empty")
                self.animationImgView.isHidden = false
                self.notAvailableCouponView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        applyCouponViewModelObj?.noFindItemsAvailableDriver.drive(onNext: { (val) in
            if(val){
              self.availableEmpty = true
              print("available empty")
              self.animationImgView.isHidden = false
              self.availableCouponView.isHidden = true
                
            }
        }).disposed(by: disposeBag)
        
        applyCouponViewModelObj?.notAvailableCouponsDrive.drive(onNext: {[weak self] (val) in

            self?.animationImgView.isHidden = true
            self?.notAvailableCouponView.isHidden = false
            
            Observable.just(val).bind(to: self!.notAvailableTableView.rx.items(cellIdentifier: Constants.NotAvailableCell)){row,item,cell in
                  (cell as? NotAvailableTableViewCell )?.discountCode.text = "Code: " + item.code!
                (cell as? NotAvailableTableViewCell )?.productType.text = ". For " + item.productType! + " products"
             }.disposed(by: self!.disposeBag)
      }).disposed(by: disposeBag)
        
        couponStateCollectionView.rx.itemSelected.subscribe{[weak self](IndexPath) in
            if( IndexPath.element![1] == 0){
                self!.notAvailableCouponView.isHidden = true
                if(self!.availableEmpty){
                    self!.availableCouponView.isHidden = true
                    self!.animationImgView.isHidden = false
                }else{
                    self!.availableCouponView.isHidden = false
                    self!.animationImgView.isHidden = true
                }
                
            }else{
               self!.availableCouponView.isHidden = true
                if(self!.NoavailableEmpty){
                   self!.notAvailableCouponView.isHidden = true
                   self!.animationImgView.isHidden = false
               }else{
                   self!.notAvailableCouponView.isHidden = false
                   self!.animationImgView.isHidden = true
               }
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
            let cell = self?.availableCoupon.cellForRow(at: IndexPath.element!) as? availableCouponTableViewCell
            cell?.isSelected = true
            self!.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
          
        availableCoupon.rx.modelSelected(Coupon.self).subscribe{[weak self](item) in
            self!.discountDelegate?.applyCoupon(coupone: "10.00" , productType : (item.element?.productType)!)
        }.disposed(by: disposeBag)
       
        applyCouponViewModelObj?.availableCouponsDrive.drive(onNext: {[weak self] (val) in
            self?.animationImgView.isHidden = true
            self?.availableCouponView.isHidden = false

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
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.availableEmpty){
            self.availableCouponView.isHidden = true
            self.animationImgView.isHidden = false
        }else{
            self.availableCouponView.isHidden = false
            self.animationImgView.isHidden = true
        }
        playBackgroundAnimation()
    }
    
    private func playBackgroundAnimation(){
        let animation = Animation.named("629-empty-box")
        backgroundAnimationView.animation = animation
       
        backgroundAnimationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop,
                           completion: { (finished) in
        })
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
