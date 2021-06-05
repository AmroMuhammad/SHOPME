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
    func getProductDetails(productId:String, completion: @escaping (Result<ProductDetailsModel?,NSError>) -> Void){
        self.fetchData(target: .getProductDetails(id: productId), responseClass: ProductDetailsModel.self) { (result) in
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

extension ShopifyAPI : CategoryAPIContract{
    func getCategoryProducts(catType: String, completion: @escaping (Result<ProductModel?, NSError>) -> Void) {
        var targetType:ApplicationNetworking = .getMenCategoryProducts
        if(catType == Constants.mainCategories[0]){  //men
            targetType = .getMenCategoryProducts
        }else if(catType == Constants.mainCategories[1]){
            targetType = .getWomenCategoryProducts
        }else{
            targetType = .getKidsCategoryProducts
        }
        
        self.fetchData(target: targetType, responseClass: ProductModel.self) { (result) in
            completion(result)
        }
        
    }
}

extension ShopifyAPI : AllProductsAPIContract{
    func getAllProducts(completion: @escaping (Result<AllProductsModel?, NSError>) -> Void) {
        self.fetchData(target: .getAllProducts, responseClass: AllProductsModel.self) { (result) in
            completion(result)
        }
    }
}
// MARK: Marwa Section
extension ShopifyAPI : allProductProtocol{
    func getDiscountCodeData(completion: @escaping (Result<discountCode?, NSError>) -> Void) {
        self.fetchData(target:.discountCode, responseClass: discountCode.self) { (result) in
            completion(result)
        }
    }
    
    func getAllMenProductData(completion: @escaping (Result<AllProduct?, NSError>) -> Void) {
        self.fetchData(target:.allMenProduct , responseClass:AllProduct.self) { (result) in
                   completion(result)
               }
    }
    
    func getAllKidsProductData(completion: @escaping (Result<AllProduct?, NSError>) -> Void) {
        self.fetchData(target:.allKidsProduct, responseClass:AllProduct.self) { (result) in
                   completion(result)
               }
    }
    
    
    func getAllWomanProductData(completion: @escaping (Result<AllProduct?, NSError>) -> Void) {
        self.fetchData(target:.allWomenProduct , responseClass:AllProduct.self) { (result) in
            completion(result)
        }
    }
    
    
}
//end


