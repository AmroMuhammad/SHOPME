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
  //  var val : [String]?
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
        
      //   val  = ["marwa" , "asmaa"]
        cartViewModelObj.dataDrive.drive(onNext: {[weak self] (val) in
        self!.cartTableView.delegate = nil
        self!.cartTableView.dataSource = nil
            Observable.just(val).bind(to: self!.cartTableView.rx.items(cellIdentifier: Constants.cartTableCell)){row,item,cell in
            (cell as? TableViewCell)?.delegate = self
                  //  (cell as? cartTableViewCell)?.productPrice.text = item
                   cell.layer.cornerRadius = 30
                   cell.layer.shadowColor = UIColor.black.cgColor
                   cell.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.layer.shadowRadius = 30
                   cell.layer.shadowOpacity = 5
                    cell.layer.masksToBounds = true
            }.disposed(by: self!.disposeBag)
        }).disposed(by: disposeBag)
        
        cartTableView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (productItem) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
            let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
            productDetailsVC.productId = "\(6687367168198)"
            self?.navigationController?.pushViewController(productDetailsVC, animated: true)
        }).disposed(by: disposeBag)
            
        cartViewModelObj.getCartData()
    }
    @objc func goToWishList() {
           let wishListViewController = storyboard?.instantiateViewController(identifier: Constants.wishListVC) as! wishListViewController
           navigationController?.pushViewController(wishListViewController, animated: true)
           
       }
   
    @IBAction func checkoutBtn(_ sender: Any) {
        
    }
}


extension CardViewController: TableViewCellDelegate {
    func updateCoreDate(stepperNum : Int) {
        cartViewModelObj.changeProductNumber(num: stepperNum)
    }
    
    func showMovingAlert(msg: String) {
        let alertController = UIAlertController(title: msg, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Move", style: .default, handler: {[weak self](action: UIAlertAction!) in
              print("Handle Ok logic here")
             self!.moveProductToWishList()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    
    func showAlert(msg: String, completion: @escaping (Int) -> Void) {
           let alertController = UIAlertController(title: msg, message: "", preferredStyle: UIAlertController.Style.alert)
           alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: {[weak self] (action: UIAlertAction!) in
                 print("Handle Ok logic here")
             completion(self!.deleteProductFromCart())
           }))
           alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                 print("Handle Cancel Logic here")
                 completion(1)
           }))
           present(alertController, animated: true, completion: nil)
       }
    
    //MARK:- DELETE FROM CORE DATA AND UPDATE Table view
       func deleteProductFromCart() -> Int{
           print("deleeeeete")
         cartViewModelObj.deleteCartData()
           return 0
       }
     //END
    
    //MARK:- DELETE FROM CORE DATA AND UPDATE Table view then add it to wish list core data
      func moveProductToWishList(){
        cartViewModelObj.moveToWishList()
          print("Moveeeeeeeeee")
      }
    //END
    
}


extension CardViewController:   UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169
    }
    
}
