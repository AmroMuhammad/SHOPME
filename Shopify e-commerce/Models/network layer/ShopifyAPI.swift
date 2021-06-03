//
//  ShopifyAPI.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/23/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
class ShopifyAPI : BaseAPI<ApplicationNetworking>{
    
    static let shared = ShopifyAPI()
    
    private override init() {}
    
    // MARK: Ahmed Section
    
    func getProductDetails(productId:String, completion: @escaping (Result<ProductModel?,NSError>) -> Void){
        self.fetchData(target: .getProductDetails(id: productId), responseClass: ProductModel.self) { (result) in
            completion(result)
        }
    }
    
    //end
    
    // MARK: Amr Section
        

    //end
    
    
    // MARK: Ayman Section
    
    //end
    
    
    // MARK: Marwa Section
    
    //end
    
}

//func getProducts(completion: @escaping (Result<ProductModel?,NSError>) -> Void){
//    self.fetchData(target: .products, responseClass: ProductModel.self) { (result) in
//        completion(result)
//    }
//}
