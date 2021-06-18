//
//  ProductDetailsContracts.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 06/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift


protocol ProductDetailsAPIType {
    func getProductDetails(productId:String, completion: @escaping (Result<ProductDetailsModel?,NSError>) -> Void)
}


protocol ProductDetailsViewModelType {
    var showErrorObservable: Observable<[String]> {get}
    var showLoadingObservable: Observable<Bool> {get}
    var showToastObservable: Observable<String> {get}
    var connectivityObservable: Observable<Bool> {get}
    
    var imagesObservable: Observable<[ProductDetailsImage]> {get}
    var colorsObservable: Observable<[UIColor]> {get}
    var sizesObservable: Observable<[String]> {get}
    var productTitleObservable: Observable<String> {get}
    var productPriceObservable: Observable<String> {get}
    var productVendorObservable: Observable<String> {get}
    var productDescriptionObservable: Observable<String> {get}
    var quantutyObservable: Observable<String> {get}
    var currencyObservable: Observable<String> {get}
    var userCityObservable: Observable<String> {get}
    var checkProductInFavoriteObservable: Observable<Bool> {get}
    var checkProductInCartObservable: Observable<(Bool, (String, Int), (UIColor, Int))> {get}
    
    func getProductDetails(id: String, mainCategory: String?)
    func getLocalData()
    func isUserLoggedIn (completion: @escaping (Bool) -> Void)
    
    func addTofavorite()
    func removefromFavorite()
    
    func checkIfCart()
    func addToCart(selectedSize: String?, selectedColor: UIColor?)
    func updateCartProduct(selectedSize: String?, selectedColor: UIColor?)
    func getCartQuantity()
}
