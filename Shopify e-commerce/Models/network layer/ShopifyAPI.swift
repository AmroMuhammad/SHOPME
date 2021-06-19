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
    static var statusCode:Int!{
        didSet{
            print("i am insdie did set in shopfi api")
        }
    }
    static var statusCodeForRegistration:Int!
    
    private override init() {}
    
    // MARK: Ahmed Section
    

    //end
    
    // MARK: Amr Section
    
        
    //end
    
    
    // MARK: Ayman Section
    func getCustomers(completion: @escaping (Result<AllCustomers?,NSError>) -> Void) {
            self.fetchData(target: .customers, responseClass: AllCustomers.self) { (results) in
                completion(results)
            }
    }
    
    
//    func addNewCustomer(customer:RegisterCustomer,complition: @escaping (Int)->Void) -> Void {
//        print(customer)
//        print(customer)
//        print(customer)
//        // prepare json data
//        let jsonData = try! JSONEncoder().encode(customer)
//        // create post request
//        let url = URL(string:Constants.fullURL)!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpShouldHandleCookies = false
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        // insert json data to the request
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil{
//                print(error!)
//
//            }
//            if let httpResponse = response as? HTTPURLResponse{
//                print("==========================================================================")
//                complition(httpResponse.statusCode)
//
//                print("=======================================================================")
//            }
//        }
//        task.resume()
//    }
    
    
//    func editCustomer(customer:RegisterCustomer,id:Int) -> Void {
//        let jsonData = try! JSONEncoder().encode(customer)
//        print(jsonData)
//        let url = URL(string: "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/admin/api/2021-04/customers/\(id).json")!
//        print("===============================The id is======================================")
//        print(id)
//        print("===============================The id is======================================")
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.httpShouldHandleCookies = false
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        // insert json data to the request
//        request.httpBody = jsonData
//        let task = URLSession.shared.dataTask(with: request,completionHandler: registrationHandler(data:response:error:))
//        task.resume()
//
//    }
    
    
//    func registrationHandler(data:Data?,response:URLResponse?,error:Error?) -> Void {
//        if error != nil{
//            print(error!.localizedDescription)
//        }
//        if let httpResponse = response as? HTTPURLResponse{
//            print("==========================================================================")
//            print("\(httpResponse.statusCode)")
//
////            if httpResponse.statusCode == 201 {
////                <#code#>
////            }
//           // ShopifyAPI.statusCodeForRegistration = httpResponse.statusCode
//            print("==========================================================================")
//        }
//        if let safeData = data{
//
//        }
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

extension ShopifyAPI: ProductDetailsAPIType {
    func getProductDetails(productId:String, completion: @escaping (Result<ProductDetailsModel?,NSError>) -> Void){
        self.fetchData(target: .getProductDetails(id: productId), responseClass: ProductDetailsModel.self) { (result) in
            completion(result)
        }
    }
}

   
