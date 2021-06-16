//
//  addressViewController.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/15/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class addressViewController: UIViewController {
    var disposeBag = DisposeBag()
    var allCartProduct : [LocalProductDetails]?
    var totalPriceForReceipt : String?
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn.layer.cornerRadius = addBtn.bounds.height / 2
        addBtn.layer.masksToBounds = true
        addressTableView.delegate = self
        Observable.just(["Available","Not Available"]).bind(to: addressTableView.rx.items(cellIdentifier: Constants.addressCell)){row,item,cell in
            // (cell as? addressTableViewCell )?.lbl.text = item
        }.disposed(by: disposeBag)
         
         addressTableView.rx.itemSelected.subscribe{[weak self](IndexPath) in
            let receiptViewController = self!.storyboard?.instantiateViewController(identifier: Constants.receiptVC) as! receiptViewController
            receiptViewController.allCartProductForReceipt = self!.allCartProduct
            receiptViewController.totalCartPrice = self!.totalPriceForReceipt
            self!.navigationController?.pushViewController(receiptViewController, animated: true)
         }.disposed(by: disposeBag)
    }
    

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? addAddressViewController {
            if segue.identifier == "add" {
                controller.modalPresentationStyle = .custom
            }
        }
    }
    
}

extension addressViewController :   UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
        
    }
    
}
