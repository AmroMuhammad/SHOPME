//
//  ShopifyAPI.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/23/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import Alamofire
class ShopifyAPI : BaseAPI<ApplicationNetworking>{
    
    static let shared = ShopifyAPI()
    static var statusCode:Int!
    static var statusCodeForRegistration:Int!
    
    private override init() {}
    
    // MARK: Ahmed Section
    
//    func getProductDetails(productId:String, completion: @escaping (Result<ProductModel?,NSError>) -> Void){
//        self.fetchData(target: .getProductDetails(id: productId), responseClass: ProductModel.self) { (result) in
    func getProductDetails(productId:String, completion: @escaping (Result<ProductDetailsModel?,NSError>) -> Void){
        self.fetchData(target: .getProductDetails(id: productId), responseClass: ProductDetailsModel.self) { (result) in
            completion(result)
        }
    }
    
    //end
    
    // MARK: Amr Section
    
    
    //end
    
    
    // MARK: Ayman Section
    func getCustomers(completion: @escaping (Result<Customer?,NSError>) -> Void) {
            self.fetchData(target: .customers, responseClass: Customer.self) { (results) in
                
                completion(results)
            }
    }
    
    
    func addNewCustomer(customer:RegisterCustomer) -> Void {
        // prepare json data
        let jsonData = try! JSONEncoder().encode(customer)
        // create post request
        let url = URL(string:Constants.fullURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = false
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        // insert json data to the request
        request.httpBody = jsonData
       
        let task = URLSession.shared.dataTask(with: request,completionHandler: handler(data:response:error:))
        task.resume()
    }
    func handler(data:Data?,response:URLResponse?,error:Error?) -> Void {
        if error != nil{
            print(error!)

        }
        if let httpResponse = response as? HTTPURLResponse{
            print("==========================================================================")
            print("\(httpResponse.statusCode)")
            ShopifyAPI.statusCode = httpResponse.statusCode
            print("==========================================================================")
        }
        if let safeData = data{
        }
    }
    
    
    func editCustomer(customer:RegisterCustomer) -> Void {
        let jsonData = try! JSONEncoder().encode(customer)
        let url = URL(string: "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/admin/api/2021-04/customers/\(customer.customer.id).json")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpShouldHandleCookies = false
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        // insert json data to the request
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request,completionHandler: registrationHandler(data:response:error:))
        task.resume()
       
    }
    
    
    func registrationHandler(data:Data?,response:URLResponse?,error:Error?) -> Void {
        if error != nil{
            print(error!.localizedDescription)
        }
        if let httpResponse = response as? HTTPURLResponse{
            print("==========================================================================")
            print("\(httpResponse.statusCode)")
            ShopifyAPI.statusCodeForRegistration = httpResponse.statusCode
            print("==========================================================================")
        }
        if let safeData = data{
            
        }
    /*func ayman()->Void{
        let array = [ "one", "two" ]
        let data = NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding.rawValue)
        
        
        
    var request = URLRequest(url: URL(string: "url")!)
    
    request.httpMethod = HTTPMethod.post.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       // var array:[CustomerElement]!
    //let pjson = array.toJSONString(prettyPrint: false)
    //let data = (pjson?.data(using: UTF8))! as Data

    //request.httpBody = data
    
    AF.request(request).responseJSON { (response) in


        print(response)
    }

    }*/
    //end
    
    
    // MARK: Marwa Section
    
    //end
    
}

//func getProducts(completion: @escaping (Result<ProductModel?,NSError>) -> Void){
//    self.fetchData(target: .products, responseClass: ProductModel.self) { (result) in
//        completion(result)
//    }
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
