//
//  addressViewController.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/15/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class addressViewController: UIViewController {
    var disposeBag = DisposeBag()
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTableView.delegate = self
       Observable.just(["Available","Not Available"]).bind(to: addressTableView.rx.items(cellIdentifier: "addressTableViewCell")){row,item,cell in
           // (cell as? addressTableViewCell )?.lbl.text = item
        }.disposed(by: disposeBag)
        
        addressTableView.rx.itemSelected.subscribe{[weak self](IndexPath) in
           // self!.applyChanges(index: IndexPath.element![1])
        }.disposed(by: disposeBag)
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        
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

