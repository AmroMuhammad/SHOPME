//
//  wishListViewController.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/4/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class wishListViewController: UIViewController {
    var wishListViewModelObj : wishListViewModelType!
    @IBOutlet weak var toolBar: UIToolbar!
    private let disposeBag = DisposeBag()
    @IBOutlet weak var noItemImg: UIImageView!
    @IBOutlet weak var wishListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishListViewModelObj = wishListViewModel()
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "shopping"), for: [])
        button.addTarget(self, action: #selector(doToCart), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
         wishListViewModelObj.dataDrive.drive(onNext: {[weak self] (val) in
            if(val.count == 0){
                self?.wishListEmpty()
            }else{
                self?.wishListNotEmpty()
                self!.wishListCollectionView.delegate = nil
                self!.wishListCollectionView.dataSource = nil
            Observable.just(val).bind(to: self!.wishListCollectionView.rx.items(cellIdentifier: Constants.wishListCell)){row,item,cell in
                (cell as? wishListCollectionViewCell)?.cellProduct = item
            (cell as? wishListCollectionViewCell)?.delegate = self
         //   cell.layer.cornerRadius = 20
            cell.layer.borderWidth = 0.0
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 1
            cell.layer.masksToBounds = true
            }.disposed(by: self!.disposeBag)
        }
    }).disposed(by: disposeBag)
        
       wishListViewModelObj.errorDrive.drive(onNext: {[weak self] (val) in
            if(val){
                self!.wishListEmpty()
            }
        }).disposed(by: disposeBag)
        
        wishListCollectionView.rx.modelSelected(LocalProductDetails.self).subscribe(onNext: {[weak self] (productItem) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
            let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
            productDetailsVC.productId = "\(productItem.productId)"
            self?.navigationController?.pushViewController(productDetailsVC, animated: true)
        }).disposed(by: disposeBag)
        
//        wishListViewModelObj.getwishListData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wishListViewModelObj.getwishListData()
    }

         
    @objc func doToCart() {
        if checkVC(addedVC: CardViewController.self) {
            print("checkVC is NOT nil")
            navigationController?.popViewController(animated: true)
        } else {
            print("checkVC is NIIIIIIIL")
            
            let cartViewController = storyboard?.instantiateViewController(identifier: Constants.cartVC) as! CardViewController
            navigationController?.pushViewController(cartViewController, animated: true)
        }
    }
    func wishListEmpty() {
        print("it is empty ................")
        self.wishListCollectionView.isHidden = true
        self.toolBar.isHidden = true
        self.noItemImg.isHidden = false
    }
   func wishListNotEmpty() {
       self.wishListCollectionView.isHidden = false
       self.toolBar.isHidden = false
       self.noItemImg.isHidden = true
       print("it not is empty ................")
   }
  
}


extension wishListViewController: CollectionViewCellDelegate{
    func showMovingAlert(msg: String , product : LocalProductDetails) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: "add", style: .default, handler: { [weak self](action: UIAlertAction!) in
              print("Handle Ok logic here")
            self!.wishListViewModelObj.addToCart(product : product)
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(msg : String , product : LocalProductDetails) {
      
      let alertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)

      alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            print("Handle Ok logic here")
        self!.wishListViewModelObj.deleteWishListData(product: product)
      }))

      alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
      }))

      present(alertController, animated: true, completion: nil)
    }

}
