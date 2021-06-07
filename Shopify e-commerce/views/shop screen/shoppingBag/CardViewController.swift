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
class CardViewController: UIViewController  {

    var disposeBag = DisposeBag()
      var val : [String]?
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var lastView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        lastView.layer.cornerRadius = 30
        lastView.layer.shadowColor = UIColor.black.cgColor
                         //  lastView.layer.shadowOffset = //CGSize(width: 10, height: 10)
                         //  lastView.layer.shadowRadius = 5.0
                         //  lastView.layer.shadowOpacity = 1
                     //     lastView.layer.masksToBounds = true
        view.layer.shadowOffset = CGSize(width: 10,
                                          height: 10)
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
        
         val  = ["marwa" , "asmaa" ,"marwa" , "asmaa" ]
        Observable.just(val!).bind(to: cartTableView.rx.items(cellIdentifier: Constants.cartTableCell)){row,item,cell in
            (cell as? TableViewCell)?.delegate = self
                  //  (cell as? cartTableViewCell)?.productPrice.text = item
                 cell.layer.cornerRadius = 30
//                    cell.layer.borderWidth = 0.0
            cell.layer.shadowColor = UIColor.black.cgColor
                   cell.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.layer.shadowRadius = 30
                   cell.layer.shadowOpacity = 5
                   cell.layer.masksToBounds = true
//                   cell.backgroundColor = UIColor.white
//                   cell.layer.borderColor = UIColor.black.cgColor
//                   cell.layer.borderWidth = 1
//                   cell.layer.cornerRadius = 8
//                   cell.clipsToBounds = true
//            cell.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                }.disposed(by: disposeBag)
                
                cartTableView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (productItem) in
                    let storyBoard : UIStoryboard = UIStoryboard(name: "productDetails", bundle:nil)
                    let productDetailsVC = storyBoard.instantiateViewController(identifier: Constants.productDetailsVC) as! ProductDetailsTableViewController
                    productDetailsVC.productId = "\(6687367168198)"
                    self?.navigationController?.pushViewController(productDetailsVC, animated: true)
                }).disposed(by: disposeBag)
        
    }
    @objc func goToWishList() {
           let wishListViewController = storyboard?.instantiateViewController(identifier: Constants.wishListVC) as! wishListViewController
           navigationController?.pushViewController(wishListViewController, animated: true)
           
       }
   
}


extension CardViewController: TableViewCellDelegate {
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
           return 0
       }
     //END
    
    //MARK:- DELETE FROM CORE DATA AND UPDATE Table view then add it to wish list core data
      func moveProductToWishList(){
          print("Moveeeeeeeeee")
      }
    //END
    
}


extension CardViewController:   UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169
    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 20))
////
////        let label = UILabel()
////        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//////        label.text = "Notification Times"
//////        label.font = .systemFont(ofSize: 16)
//////        label.textColor = .yellow
////
////        headerView.addSubview(label)
//
//        return 20
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
////        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 20))
////
////        let label = UILabel()
////        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//////        label.text = "Notification Times"
//////        label.font = .systemFont(ofSize: 16)
//////        label.textColor = .yellow
////
////        headerView.addSubview(label)
//
//        return 20
//    }
    
}
