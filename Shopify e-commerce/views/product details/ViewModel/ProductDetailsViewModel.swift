//
//  ProductDetailsViewModel.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 03/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation

class ProductDetailsViewModel {
    
    private var shopifyAPI: ShopifyAPI!
    private var controller: ProductDetailsTableViewController!
    
    
    init(cont: ProductDetailsTableViewController) {
        shopifyAPI = ShopifyAPI.shared
        controller = cont
    }
    
    func getProductDetails(id: String){
        shopifyAPI.getProductDetails(productId: id) { (result) in
            switch(result){
            case .success(let product):
                self.controller.proDetObs = product?.product
                print("VM => id => \(product?.product.id ?? 707)")
            case .failure(let err):
                print("\n\n\n\n errrrr => \(err.localizedDescription) \nEND\n\n\n\n")
            }
        }
    }
    
    /*
     case .success(let cat):
         self?.data = cat?.products
         let filteredData = self?.data?.filter({(catItem) -> Bool in
             catItem.productType.capitalized == subCat.capitalized
         })
         self?.productDatasubject.onNext(filteredData ?? [])
         self?.data = filteredData
         self?.Loadingsubject.onNext(false)
     case .failure(let error):
         self?.Loadingsubject.onNext(false)
         self?.errorsubject.onError(error)
     */
}
