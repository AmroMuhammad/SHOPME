//
//  receiptViewModel.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/11/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class receiptViewModel : receiptViewModelType {
   
    var itemNumDrive: Driver<Int>
    var disposeBag = DisposeBag()
    var itemNumSubject = PublishSubject<Int>()
    
    init() {
       itemNumDrive = itemNumSubject.asDriver(onErrorJustReturn: 0 )
    }
    func getItemNum(products: [LocalProductDetails]) {
        var totalItemNum : Int = 0
        var count = 0
        while count < products.count {
            totalItemNum  += products[count].quantity!
            count += 1
        }
        itemNumSubject.onNext(totalItemNum)
    }
    
}
