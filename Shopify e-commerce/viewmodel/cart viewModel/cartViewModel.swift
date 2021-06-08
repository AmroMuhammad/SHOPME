//
//  cartViewModel.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/7/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class cartViewModel : cartViewModelType {
    var disposeBag = DisposeBag()
    var dataDrive: Driver<[String]>
    var dataSubject = PublishSubject<[String]>()
    
    init() {
        dataDrive = dataSubject.asDriver(onErrorJustReturn: [] )
    }
    func getCartData() {
        //get data from core data
        dataSubject.onNext(["marwa" , "asmaa" , "omar" , "sleem", "rovan" , "marwa"])
    }
    func moveToWishList() {
      //  delete from cart core data and add to wishlist core data
        dataSubject.onNext([])
       // getCartData()
    }
    func deleteCartData() {
      //  delete from cart core data
        dataSubject.onNext([])
        //getCartData()
    }
    func changeProductNumber(num : Int){
        print("\(num)")
        //call when stepper clicked and update core data
    }
    
}
