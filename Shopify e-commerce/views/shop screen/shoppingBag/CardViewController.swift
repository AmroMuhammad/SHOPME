//
//  CardViewController.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/4/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class CardViewController: UIViewController {
    var cartViewModelObj : cartViewModelType!
    var disposeBag = DisposeBag()
    var allCartProduct : [CartProduct]?
   
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var noItemImg: UIImageView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var lastView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cartViewModelObj = cartViewModel()
        lastView.layer.cornerRadius = 30
        lastView.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 10,height: 10)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        self.cartTableView.delegate = self
        self.cartTableView.sectionHeaderHeight = 70
        self.cartTableView.sectionFooterHeight = 70
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
               button.setImage(UIImage(named: "like"), for: [])
               button.addTarget(self, action: #selector(goToWishList), for: UIControl.Event.touchUpInside)
               button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
               let barButton = UIBarButtonItem(customView: button)
               self.navigationItem.rightBarButtonItem = barButton
        
        cartViewModelObj.totalPriceDrive.drive(onNext: {[weak self] (val) in
            self!.totalPrice.text = "\(val)"
        }).disposed(by: disposeBag)
        
        
        cartViewModelObj.dataDrive.drive(onNext: {[weak self] (val) in
           
            self!.allCartProduct = val
            if(val.count == 0){
                self!.cartEmpty()
            }else{
                self!.cartNotEmpty()
        self!.cartTableView.delegate = nil
        self!.cartTableView.dataSource = nil
            Observable.just(val).bind(to: self!.cartTableView.rx.items(cellIdentifier: Constants.cartTableCell)){row,item,cell in
            (cell as? TableViewCell)?.delegate = self
                (cell as? TableViewCell)?.cellCartProduct = item
                   cell.layer.cornerRadius = 30
                   cell.layer.shadowColor = UIColor.black.cgColor
                   cell.layer.shadowOffset = CGSize(width: 0, height: 0)
                   cell.layer.shadowRadius = 30
                   cell.layer.shadowOpacity = 5
                   cell.layer.masksToBounds = true
            }.disposed(by: self!.disposeBag)
        }
        }).disposed(by: disposeBag)
        
        cartTableView.rx.modelSelected(CartProduct.self).subscribe(onNext: {[weak self] (productItem) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
            let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
            productDetailsVC.productId = "\(productItem.productId)"
            self?.navigationController?.pushViewController(productDetailsVC, animated: true)
        }).disposed(by: disposeBag)
            
        cartViewModelObj.getCartData()
    }
    @objc func goToWishList() {
           let wishListViewController = storyboard?.instantiateViewController(identifier: Constants.wishListVC) as! wishListViewController
           navigationController?.pushViewController(wishListViewController, animated: true)
           
    }
    func cartEmpty() {
        print("it is empty ................")
        self.cartTableView.isHidden = true
        self.lastView.isHidden = true
        self.noItemImg.isHidden = false
    }
    
    func cartNotEmpty() {
        self.cartTableView.isHidden = false
        self.lastView.isHidden = false
        self.noItemImg.isHidden = true
        print("it is not empty ................")
    }
   
    @IBAction func checkoutBtn(_ sender: Any) {
        let receiptViewController = storyboard?.instantiateViewController(identifier: Constants.receiptVC) as! receiptViewController
        receiptViewController.allCartProductForReceipt = allCartProduct
        receiptViewController.totalCartPrice = totalPrice.text
        navigationController?.pushViewController(receiptViewController, animated: true)
    }
}


extension CardViewController: TableViewCellDelegate {
    func updateCoreDate(product: CartProduct) {
        cartViewModelObj.changeProductNumber(product: product)
    }
    
    func showMovingAlert(msg: String , product:CartProduct) {
        let alertController = UIAlertController(title: msg, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Move", style: .default, handler: {[weak self](action: UIAlertAction!) in
              print("Handle Ok logic here")
            self!.moveProductToWishList(product: product)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    
    func showAlert(msg: String, product:CartProduct, completion: @escaping (Int) -> Void) {
           let alertController = UIAlertController(title: msg, message: "", preferredStyle: UIAlertController.Style.alert)
           alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: {[weak self] (action: UIAlertAction!) in
                 print("Handle Ok logic here")
             completion(self!.deleteProductFromCart(product: product))
           }))
           alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                 print("Handle Cancel Logic here")
                 completion(1)
           }))
           present(alertController, animated: true, completion: nil)
       }
    
    //MARK:- DELETE FROM CORE DATA AND UPDATE Table view
       func deleteProductFromCart(product: CartProduct) -> Int{
           print("deleeeeete")
         cartViewModelObj.deleteCartData(product: product)
           return 0
       }
     //END
    
    //MARK:- DELETE FROM CORE DATA AND UPDATE Table view then add it to wish list core data
    func moveProductToWishList(product:CartProduct){
        cartViewModelObj.moveToWishList(product: product)
          print("Moveeeeeeeeee")
      }
    //END
    
}


extension CardViewController:   UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169
    }
    
}
