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
    var addressViewModelObj : addressViewModelType?
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressViewModelObj = addressViewModel()
        addBtn.layer.cornerRadius = addBtn.bounds.height / 2
        addBtn.layer.masksToBounds = true
        addressTableView.delegate = self
        
        addressViewModelObj?.userDefaultAddressDriver.drive(onNext: { [weak self](allAddresses) in
            print("allAddresses : \(allAddresses)")
            Observable.just(allAddresses).bind(to: self!.addressTableView.rx.items(cellIdentifier: Constants.addressCell)){row,item,cell in
              let addressDetails = self!.addressViewModelObj?.getAddressDetails(address: item)
                print("addressDetails : \(addressDetails ?? [])")
                if(addressDetails!.count > 0){
                    (cell as? addressTableViewCell )?.addressLabel.text = addressDetails![0]
                    (cell as? addressTableViewCell )?.countryAndCity.text = addressDetails![1] + " " + addressDetails![2]
                }
                
            }.disposed(by: self!.disposeBag)
            
        }).disposed(by: disposeBag)
         
         addressTableView.rx.itemSelected.subscribe{[weak self](IndexPath) in
            let receiptViewController = self!.storyboard?.instantiateViewController(identifier: Constants.receiptVC) as! receiptViewController
            receiptViewController.allCartProductForReceipt = self!.allCartProduct
            receiptViewController.totalCartPrice = self!.totalPriceForReceipt
            self!.navigationController?.pushViewController(receiptViewController, animated: true)
         }.disposed(by: disposeBag)
        
        addressViewModelObj?.getUserDefaultAddress()
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
        return 105
        
    }
    
}
