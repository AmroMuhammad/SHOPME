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
    func getProductDetails(id: String, mainCategory: String?)
    func getLocalData()

    var imagesObservable: Observable<[ProductDetailsImage]> {get}
    var colorsObservable: Observable<[UIColor]> {get}
    var sizesObservable: Observable<[String]> {get}
    var productTitleObservable: Observable<String> {get}
    var productPriceObservable: Observable<String> {get}
}
