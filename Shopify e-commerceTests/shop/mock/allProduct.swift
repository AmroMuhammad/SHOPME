//
//  allProduct.swift
//  Shopify e-commerceTests
//
//  Created by marwa on 6/18/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
@testable import Shopify_e_commerce
class AllProduct{
    
    
    var shouldReturnError : Bool
    
    init(shouldReturnError : Bool) {
        
        self.shouldReturnError = shouldReturnError
    }
    
    var error : Error!
    
    let mockAllProductJSONResponse : Array<[String:Any]> = [
    [
        "id": 6687367430342,
        "title": "VANS APPAREL AND ACCESSORIES | CLASSIC SUPER NO SHOW SOCKS 3 PACK WHITE",
        "body_html": "The classic super no show socks are for all your low top shoes like Classic Slip-Ons. These socks are designed to stay hidden under your shoes for an athletic look with either jeans or shorts. Thin walled breathable cotton/nylon blend.",
        "vendor": "VANS",
        "product_type": "ACCESSORIES",
        "created_at": "2021-05-17T23:50:16+02:00",
        "handle": "vans-apparel-and-accessories-classic-super-no-show-socks-3-pack-white",
        "updated_at": "2021-06-18T11:10:30+02:00",
        "published_at": "2021-05-17T23:50:16+02:00",
        "status": "active",
        "published_scope": "web",
        "tags": "egnition-sample-data, unisex, vans",
        "admin_graphql_api_id": "gid://shopify/Product/6687367430342",
        "options": [
            [
                "id": 8585098723526,
                "product_id": 6687367430342,
                "name": "Size",
                "position": 1
            ],
            [
                "id": 8585098756294,
                "product_id": 6687367430342,
                "name": "Color",
                "position": 2
            ]
        ],
        "images": [
            [
                "id": 29002674667718,
                "product_id": 6687367430342,
                "position": 1,
                "created_at": "2021-05-17T23:50:16+02:00",
                "updated_at": "2021-05-17T23:50:16+02:00",
                "width": 635,
                "height": 560,
                "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/ccba62c19289e4b5f14b180c05836614.jpg?v=1621288216",
                "variant_ids": [],
                "admin_graphql_api_id": "gid://shopify/ProductImage/29002674667718"
            ],
            [
                "id": 29002674733254,
                "product_id": 6687367430342,
                "position": 2,
                "created_at": "2021-05-17T23:50:16+02:00",
                "updated_at": "2021-05-17T23:50:16+02:00",
                "width": 635,
                "height": 560,
                "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/c872c818621155d8fb535ee9d9c98803.jpg?v=1621288216",
                "variant_ids": [],
                "admin_graphql_api_id": "gid://shopify/ProductImage/29002674733254"
            ]
        ],
        "image": [
            "id": 29002674667718,
            "product_id": 6687367430342,
            "position": 1,
            "created_at": "2021-05-17T23:50:16+02:00",
            "updated_at": "2021-05-17T23:50:16+02:00",
            "width": 635,
            "height": 560,
            "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/ccba62c19289e4b5f14b180c05836614.jpg?v=1621288216",
            "variant_ids": [],
            "admin_graphql_api_id": "gid://shopify/ProductImage/29002674667718"
        ]
    ],
    [
        "id": 6687366906054,
        "title": "DR MARTENS | 1460Z DMC 8-EYE BOOT | CHERRY SMOOTH",
        "body_html": "Make a statement with these iconic Dr Marten boots. This classic style has stood the test of time thanks to the combination of reinvented styling and the rugged yet urban look. Crafted with high-quality, durable leathers, the 1460OZ DMC 8-Eye Boot Cherry Smooth is made to last and will only get better with time. This lace-up boot features the iconic Dr Martens air-cushioned sole offering good abrasion and slip resistance, and is made with Goodyear welt - the sole and upper are heat-sealed and sewn together.",
        "vendor": "DR MARTENS",
        "product_type": "SHOES",
        "created_at": "2021-05-17T23:49:55+02:00",
        "handle": "dr-martens-1460z-dmc-8-eye-boot-cherry-smooth",
        "updated_at": "2021-06-19T02:40:38+02:00",
        "published_at": "2021-05-17T23:49:55+02:00",
        "status": "active",
        "published_scope": "web",
        "tags": "autumn, drmartens, egnition-sample-data, spring, women",
        "admin_graphql_api_id": "gid://shopify/Product/6687366906054",
        "options": [
            [
                "id": 8585097969862,
                "product_id": 6687366906054,
                "name": "Size",
                "position": 1
            ],
            [
                "id": 8585098002630,
                "product_id": 6687366906054,
                "name": "Color",
                "position": 2
            ]
        ],
        "images": [
            [
                "id": 29002670145734,
                "product_id": 6687366906054,
                "position": 1,
                "created_at": "2021-05-17T23:49:56+02:00",
                "updated_at": "2021-05-17T23:49:56+02:00",
                "width": 635,
                "height": 560,
                "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/633e8800dbc6dc5704b35fd027e4eeaa.jpg?v=1621288196",
                "variant_ids": [],
                "admin_graphql_api_id": "gid://shopify/ProductImage/29002670145734"
            ],
            [
                "id": 29002670178502,
                "product_id": 6687366906054,
                "position": 2,
                "created_at": "2021-05-17T23:49:56+02:00",
                "updated_at": "2021-05-17T23:49:56+02:00",
                "width": 635,
                "height": 560,
                "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/03b22296d47b97717f066ad08efa188a.jpg?v=1621288196",
                "variant_ids": [],
                "admin_graphql_api_id": "gid://shopify/ProductImage/29002670178502"
            ],
            [
                "id": 29002670211270,
                "product_id": 6687366906054,
                "position": 3,
                "created_at": "2021-05-17T23:49:56+02:00",
                "updated_at": "2021-05-17T23:49:56+02:00",
                "width": 635,
                "height": 560,
                "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/46bfe44252168c8026e3f193a9cae058.jpg?v=1621288196",
                "variant_ids": [],
                "admin_graphql_api_id": "gid://shopify/ProductImage/29002670211270"
            ],
            [
                "id": 29002670244038,
                "product_id": 6687366906054,
                "position": 4,
                "created_at": "2021-05-17T23:49:56+02:00",
                "updated_at": "2021-05-17T23:49:56+02:00",
                "width": 635,
                "height": 560,
                "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/908519f7cd4790765ebf6f2c88d5275a.jpg?v=1621288196",
                "variant_ids": [],
                "admin_graphql_api_id": "gid://shopify/ProductImage/29002670244038"
            ],
            [
                "id": 29002670276806,
                "product_id": 6687366906054,
                "position": 5,
                "created_at": "2021-05-17T23:49:56+02:00",
                "updated_at": "2021-05-17T23:49:56+02:00",
                "width": 635,
                "height": 560,
                "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/f4ee52a9e1ea7d0c5b959fe475d2418f.jpg?v=1621288196",
                "variant_ids": [],
                "admin_graphql_api_id": "gid://shopify/ProductImage/29002670276806"
            ]
        ],
        "image": [
            "id": 29002670145734,
            "product_id": 6687366906054,
            "position": 1,
            "created_at": "2021-05-17T23:49:56+02:00",
            "updated_at": "2021-05-17T23:49:56+02:00",
            "width": 635,
            "height": 560,
            "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/633e8800dbc6dc5704b35fd027e4eeaa.jpg?v=1621288196",
            "variant_ids": [],
            "admin_graphql_api_id": "gid://shopify/ProductImage/29002670145734"
        ]
    ]]
    
}
enum ResponseeError : Error {
    case responseWithError
}



extension AllProduct{
    
    func fetchProductData(completion : @escaping ([Product]?, Error?)->()) {
        var product = [Product]()
        do{
            
            let allProductData = try JSONSerialization.data(withJSONObject: mockAllProductJSONResponse, options: .fragmentsAllowed)
            
            
           product = try JSONDecoder().decode([Product].self, from: allProductData)
            
        }catch let error{
            
            print(error.localizedDescription)
            
        }
        
        
        if shouldReturnError{
            
            completion(nil , ResponseeError.responseWithError)
            
        }else{
            
            completion(product , nil)
        }
       
    }
    
    
}
