//
//  shopViewController.swift
//  Shopify e-commerce
//
//  Created by marwa on 5/25/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class shopViewController: UIViewController {
    var shopProductViewModel : viewModelType!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("marwaaaaaaaaaaaaa")
        shopProductViewModel = shopViewModel()
        shopProductViewModel.loadingDriver.drive(onNext: { (loadVal) in
             print("\(loadVal)")
            }).disposed(by: disposeBag)
        
         shopProductViewModel.dataDrive.drive(onNext: { (val) in
             print(val)
         }).disposed(by: disposeBag)

         shopProductViewModel.errorDriver.drive(onNext: { (errorVal) in
             print("\(errorVal)")
         }).disposed(by: disposeBag)
           shopProductViewModel.fetchData()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
