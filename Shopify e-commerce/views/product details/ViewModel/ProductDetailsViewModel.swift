//
//  ProductDetailsViewModel.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 03/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift

class ProductDetailsViewModel {
    
    var productDetailsDataObservable: Observable<Product>
    
    private var productDetailsDataSubject = PublishSubject<Product>()
    
    
    private var shopifyAPI: ShopifyAPI!
    //private var controller: ProductDetailsTableViewController!
    
    
    init() {
        productDetailsDataObservable = productDetailsDataSubject.asObservable()
        
        shopifyAPI = ShopifyAPI.shared
        //controller = cont
    }
    
    func getProductDetails(id: String){
        shopifyAPI.getProductDetails(productId: id) { (result) in
            switch(result){
            case .success(let product):
//                self.controller.proDetObs = product?.product
                print("VM => id => \(product?.product.id ?? 707)")
                if let productResponse = product {
                    self.productDetailsDataSubject.onNext(productResponse.product)
                }
            case .failure(let err):
                print("\n\n\n\n errrrr => \(err.localizedDescription) \nEND\n\n\n\n")
            }
        }
    }
    
    func getDeliverCity(){
        //get city name to deliver from local 
    }
    
}
