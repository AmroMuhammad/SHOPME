//
//  productProtocol.swift
//  Shopify e-commerce
//
//  Created by marwa on 5/26/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Stripe

protocol allProductProtocol {
    func getAllWomanProductData(completion : @escaping (Result<AllProduct?, NSError > ) -> Void)
    func getAllMenProductData(completion : @escaping (Result<AllProduct?, NSError > ) -> Void)
    func getAllKidsProductData(completion : @escaping (Result<AllProduct?, NSError > ) -> Void)
    func getDiscountCodeData(completion : @escaping (Result<discountCode?, NSError > ) -> Void)
}
protocol viewModelType {
   
    var loadingDriver : Driver<Bool>{get}
    var errorDriver : Driver<String>{get}
    
}

protocol shopViewModelType : viewModelType {
    var connectivityDriver: Driver<Bool> {get}
    var dataDrive : Driver<[Product]> {get}
    var  discountCodeDrive : Driver<[DiscountCodeElement]> {get}
    var quantutyObservable: Observable<Int> {get}
    func getCartQuantity() 
    func fetchWomenData()
    func fetchMenData()
    func fetchKidsData()
    func fetchDiscountCodeData()
}
protocol CollectionViewCellDelegate{
    func showAlert(msg : String ,  product : LocalProductDetails)
    func showMovingAlert(msg: String ,  product : LocalProductDetails)
}

protocol TableViewCellDelegate {
    func showAlert(msg: String, product:LocalProductDetails , completion: @escaping (Int) -> Void)
    func showMovingAlert(msg: String , product:LocalProductDetails)
    func ShowMaximumAlert(msg: String)
    func updateCoreDate(product:LocalProductDetails)
    
}

protocol wishListViewModelType {
     var dataDrive : Driver<[LocalProductDetails]> {get}
     var errorDrive: Driver<Bool>{get}
    var quantutyObservable: Observable<String> {get}
     func getwishListData()
     func addToCart( product : LocalProductDetails)
     func deleteWishListData( product : LocalProductDetails)
    func getCartQuantity()
}
protocol cartViewModelType {
     var totalPriceDrive: Driver<Double>{get}
     var dataDrive : Driver<[LocalProductDetails]> {get}
     var errorDrive : Driver<Bool> {get}
     func getCartData()
     func moveToWishList(product:LocalProductDetails)
     func deleteCartData(product: LocalProductDetails)
     func changeProductNumber(product: LocalProductDetails)
     
}
protocol receiptViewModelType {
    
    func getItemNum(products: [LocalProductDetails])
    func getAllProductType(products: [LocalProductDetails])
    func fetchData(paymentTextField:STPPaymentCardTextField,viewController:UIViewController)
    var errorObservable:Observable<String>{get}
    var loadingObservable:Observable<Bool>{get}
    var dataObservable:Observable<String>{get}
    var itemNumDrive: Driver<Int>{get}
    var allProductTypeDrive: Driver<[String]>{get}

}
protocol applyCouponDelegate {
    func applyCoupon(coupone : String , productType : String)
}
