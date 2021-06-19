//
//  MochkingManager.swift
//  Shopify e-commerceTests
//
//  Created by Amr Muhammad on 6/19/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
@testable import Shopify_e_commerce
class MochkingManager: BaseAPI<ApplicationNetworking>{
    //var isError:Bool
    
    //let error:Error!
    let shopifyAPI = ShopifyAPI.shared
    
    let response:Array<[String:Any?]> = [[
    
    "id": 5283916480710,
    "email": "tmatm@gmail.com",
    "accepts_marketing": false,
    "created_at": "2021-06-19T15:32:12+02:00",
    "updated_at": "2021-06-19T15:34:28+02:00",
    "first_name": "tamatm",
    "last_name": "tmatm",
    "orders_count": 1,
    "state": "enabled",
    "total_spent": "50.00",
    "last_order_id": 3857422844102,
    "note": "Aa1234567",
    "verified_email": true,
    "multipass_identifier": nil,
    "tax_exempt": false,
    "phone": nil,
    "tags": "",
    "last_order_name": "#1692",
    "currency": "EGP"
    ],[
        "id": 5283916480710,
        "email": "tmatm@gmail.com",
        "accepts_marketing": false,
        "created_at": "2021-06-19T15:32:12+02:00",
        "updated_at": "2021-06-19T15:34:28+02:00",
        "first_name": "tamatm",
        "last_name": "tmatm",
        "orders_count": 1,
        "state": "enabled",
        "total_spent": "50.00",
        "last_order_id": 3857422844102,
        "note": "Aa1234567",
        "verified_email": true,
        "multipass_identifier": nil,
        "tax_exempt": false,
        "phone": nil,
        "tags": "",
        "last_order_name": "#1692",
        "currency": "EGP"
        ]
    ]
//    "addresses": [
//    {
//    "id": 6487477125318,
//    "customer_id": 5283916480710,
//    "first_name": "tamatm",
//    "last_name": nil,
//    "company": nil,
//    "address1": "hi",
//    "address2": nil,
//    "city": "Cairo",
//    "province": "Cairo",
//    "country": "Egypt",
//    "zip": "12356",
//    "phone": "+201088523664",
//    "name": "tamatm",
//    "province_code": "C",
//    "country_code": "EG",
//    "country_name": "Egypt",
//    "default": true
//    }
//    ],
  //  ]
    /*
     shopifyAPI.getCustomers {[weak self] (result) in
         switch result{
         case .success(let AllCustomers):
             self?.data = AllCustomers?.customers
             self?.userExistance(email: email,password: password)
         case .failure(let error):
             self?.loadingSubject.onNext(false)
             self?.errorSubject.onNext((error.localizedDescription, true))
             self?.signedInSubject.onNext(false)
         }
     }
     */
    
    func getCustomers(completion: @escaping (Result<AllCustomers?,NSError>) -> Void) {
        
        var customer = Customer(id: nil, email: nil, firstName: nil, lastName: nil, phone: nil, tags: nil, addresses: nil)
        
        
        var customers = AllCustomers(customers: [customer])
        
//            self.fetchData(target: .customers, responseClass: AllCustomers.self) { (results) in
//                completion(results)
//            }
    }
    
  override init() {
//        self.isError = er
    }


}
//enum responseError :Error {
//    case responseWithError
//}

