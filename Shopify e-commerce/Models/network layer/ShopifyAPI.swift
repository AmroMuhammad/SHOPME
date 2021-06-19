//
//  ShopifyAPI.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/23/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

class ShopifyAPI : BaseAPI<ApplicationNetworking>{
    
    static let shared = ShopifyAPI()

    
    private override init() {}
    
    // MARK: Ahmed Section
    
    // ADD   =>    extension ShopifyAPI: ProductDetailsAPIType
    func getProductDetails(productId:String, completion: @escaping (Result<ProductDetailsModel?,NSError>) -> Void){
        self.fetchData(target: .getProductDetails(id: productId), responseClass: ProductDetailsModel.self) { (result) in
            completion(result)
        }
    }
    
    //end
    
    // MARK: Amr Section
    
        
    //end
    
    
    // MARK: Ayman Section
    func getCustomers(completion: @escaping (Result<AllCustomers?,NSError>) -> Void) {
            self.fetchData(target: .customers, responseClass: AllCustomers.self) { (results) in
                completion(results)
            }
    }
    
    

    //end
    
    
    // MARK: Marwa Section
    
    //end
    
//}

}


extension ShopifyAPI : CategoryAPIContract{
    func getCategoryProducts(catType: String, completion: @escaping (Result<ProductModels?, NSError>) -> Void) {
        var targetType:ApplicationNetworking = .getMenCategoryProducts
        if(catType == Constants.mainCategories[0]){  //men
            targetType = .getMenCategoryProducts
        }else if(catType == Constants.mainCategories[1]){
            targetType = .getWomenCategoryProducts
        }else{
            targetType = .getKidsCategoryProducts
        }
        
        self.fetchData(target: targetType, responseClass: ProductModels.self) { (result) in
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

extension ShopifyAPI : RegisterAPIContract{
    func addCustomer(customerData:RegisterCustomer,completion: @escaping (Result<RegisterCustomer?,NSError>) -> Void){
        self.postData(target: .postCustomer(customer: customerData), responseClass: RegisterCustomer.self) { (result) in
            completion(result)
        }
    }
}

extension ShopifyAPI : EditInfoAPIContract{
    func editCustomer(customerData:RegisterCustomer,id:Int,completion: @escaping (Result<RegisterCustomer?,NSError>) -> Void){
        self.postData(target: .putCustomer(customer: customerData, id: id), responseClass: RegisterCustomer.self) { (result) in
            completion(result)
        }
    }
    
    func getCustomer(id:Int,completion: @escaping (Result<RegisterCustomer?,NSError>) -> Void){
        self.fetchData(target: .getCustomer(id: id), responseClass: RegisterCustomer.self) { (result) in
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

extension ShopifyAPI : PaymentAPIContract{
    func createPaymentIntent(completion: @escaping STPJSONResponseCompletionBlock){
        var url = URL(string: Constants.backendURL)!
        url.appendPathComponent("create_payment_intent")
        
        AF.request(url, method: .post, parameters: [:]).validate(statusCode: 200..<300).responseJSON { (response) in
            switch(response.result){
            case .success(let json):
                completion(json as! [String:Any],nil)
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
}
//end
