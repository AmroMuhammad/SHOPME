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
    
    private override init() {}
    
    // MARK: Ahmed Section
    
    //end
    
    // MARK: Amr Section
    
    
    //end
    
    
    // MARK: Ayman Section
    func getCustomers(completion: @escaping (Result<Customer?,NSError>) -> Void) {
            self.fetchData(target: .customers, responseClass: Customer.self) { (results) in
                
                completion(results)
            }
    }
    
    static let url = "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/n/api/2021-04/customers.js"
    
    func addNewCustomer(customer:RegisterCustomer) -> Void {
        
    
        
        // prepare json data
        let jsonData = try! JSONEncoder().encode(customer)
        // create post request
        let url = URL(string: "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/admin/api/2021-04/customers.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = false
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        // insert json data to the request
        request.httpBody = jsonData
       // request.headers = ["X-Shopify-Access-Token":"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"]
        let task = URLSession.shared.dataTask(with: request,completionHandler: handler(data:response:error:))
        task.resume()
        
        
        
    }
    func handler(data:Data?,response:URLResponse?,error:Error?) -> Void {
        if error != nil{
            print(error!)

        }
        if let httpResponse = response {
            print("==========================================================================")
           // print("\(httpResponse.statusCode)") as? HTTPURLResponse
            print(httpResponse)
            
        }
        if let safeData = data{
            //safeData.
        }
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

    
//        func postCustomers(completion: @escaping (Result<Customer?,NSError>) -> Void) {
//            self.fetchData(target: .newCustomer, responseClass: Customer.self) { (results) in
//
//                    completion(results)
//                }
//        }
//    func getCustomers(completion: @escaping (Result<Customer?,NSError>) -> Void) {
//        self.fetchData(target: .customers, responseClass: Customer.self) { (results) in
//
//            completion(results)
//        }
//
//    }
    //end
    
    
    // MARK: Marwa Section
    
    //end
    
}

//func getProducts(completion: @escaping (Result<ProductModel?,NSError>) -> Void){
//    self.fetchData(target: .products, responseClass: ProductModel.self) { (result) in
//        completion(result)
//    }
//}




/*
 {
   "customer": {
     "first_name": "Steve",
     "last_name": "Lastnameson",
     "email": "steve.lastnameson@example.com",
     "phone": "+15142546011",
     "verified_email": true,
     "addresses": [
       {
         "address1": "123 Oak St",
         "city": "Ottawa",
         "province": "ON",
         "phone": "555-1212",
         "zip": "123 ABC",
         "last_name": "Lastnameson",
         "first_name": "Mother",
         "country": "CA"
       }
     ]
   }
 }

 */
