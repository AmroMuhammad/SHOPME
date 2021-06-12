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
    var Women = Coupon(code: "WOMENSALES10OFF", productType: ". For Women products")
    var Men = Coupon(code: "MENSALES10OFF", productType: ". For Men products")
    var Kids = Coupon(code: "KIDSSALES10OFF", productType: ". For Kids products")
    var availableCoupons : [Coupon] = []
    var notAvailableCoupons : [Coupon] = []
    let defaults = UserDefaults.standard
    var availableCouponsDrive: Driver<[Coupon]>
    var availableCouponsSubject = PublishSubject<[Coupon]>()
    var notAvailableCouponsDrive: Driver<[Coupon]>
    var notAvailableCouponsSubject = PublishSubject<[Coupon]>()
      init() {
         availableCouponsDrive = availableCouponsSubject.asDriver(onErrorJustReturn: [] )
         notAvailableCouponsDrive = notAvailableCouponsSubject.asDriver(onErrorJustReturn: [] )
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
        
        notAvailableCouponsSubject.onNext(notAvailableCoupons)
        availableCouponsSubject.onNext(availableCoupons)
        
    }
    
}
