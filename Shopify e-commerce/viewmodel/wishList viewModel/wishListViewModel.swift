//
//  wishListViewModel.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/7/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class wishListViewModel : wishListViewModelType{
    var disposeBag = DisposeBag()
    var dataDrive: Driver<[String]>
    var dataSubject = PublishSubject<[String]>()
       
    init() {
           dataDrive = dataSubject.asDriver(onErrorJustReturn: [] )
    }
    func getwishListData() {
        //get data from core data
        dataSubject.onNext(["marwa" , "asmaa" , "omar" , "sleem", "rovan" , "marwa"])
    }
    func addToCart() {
      //  add to cart core data and not delete from wishlist core data
        dataSubject.onNext([])
    }
    func deleteWishListData() {
      //  delete from wishlist core data
        dataSubject.onNext([])
    }
    
}
