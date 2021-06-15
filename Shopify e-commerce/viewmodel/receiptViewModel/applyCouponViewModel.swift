//
//  applyCouponViewModel.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/12/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Coupon {
    var code : String?
    var productType : String?
}

class applyCouponViewModel {
    var Women = Coupon(code: "WOMENSALES10OFF", productType: "Women")
    var Men = Coupon(code: "MENSALES10OFF", productType: "Men")
    var Kids = Coupon(code: "KIDSSALES10OFF", productType: "Kids")
    var availableCoupons : [Coupon] = []
    var notAvailableCoupons : [Coupon] = []
    let defaults = UserDefaults.standard
    var availableCouponsDrive: Driver<[Coupon]>
    var availableCouponsSubject = PublishSubject<[Coupon]>()
    var notAvailableCouponsDrive: Driver<[Coupon]>
    var notAvailableCouponsSubject = PublishSubject<[Coupon]>()
    var noFindItemsAvailableDriver: Driver<Bool>
    var noFindItemsNotAvailableDriver: Driver<Bool>
    var noFindItemsAvailableSubject = PublishSubject<Bool>()
    var noFindItemsNotAvailableSubject = PublishSubject<Bool>()
      init() {
         availableCouponsDrive = availableCouponsSubject.asDriver(onErrorJustReturn: [] )
         notAvailableCouponsDrive = notAvailableCouponsSubject.asDriver(onErrorJustReturn: [] )
         noFindItemsAvailableDriver = noFindItemsAvailableSubject.asDriver(onErrorJustReturn: false )
         noFindItemsNotAvailableDriver = noFindItemsNotAvailableSubject.asDriver(onErrorJustReturn: false )
      }
    
    func getAvailableAndUnavailableCoupons(productType : [String]) {
        
        let findWomen = productType.contains("Women")
        let findMen = productType.contains("Men")
        let findKids = productType.contains("Kids")
        
        if(defaults.bool(forKey: "Women")){
            if(findWomen){
                availableCoupons.append(Women)
            }else{
                notAvailableCoupons.append(Women)
            }
        }
        if(defaults.bool(forKey: "Men")){
            if(findMen){
                availableCoupons.append(Men)
            }else{
                notAvailableCoupons.append(Men)
            }
        }
        if(defaults.bool(forKey: "Kids")){
            if(findKids){
                availableCoupons.append(Kids)
            }else{
                notAvailableCoupons.append(Kids)
            }
        }
        
        if(availableCoupons.count == 0){
            noFindItemsAvailableSubject.onNext(true)
        }else{
          availableCouponsSubject.onNext(availableCoupons)
        }
        if(notAvailableCoupons.count == 0){
            noFindItemsNotAvailableSubject.onNext(true)
        }else{
          notAvailableCouponsSubject.onNext(notAvailableCoupons)
        }
          
    }
    
}
