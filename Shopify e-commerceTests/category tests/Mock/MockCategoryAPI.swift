//
//  MockCategoryAPI.swift
//  Shopify e-commerceTests
//
//  Created by Amr Muhammad on 6/19/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
@testable import Shopify_e_commerce

class MockCategoryAPI{
    var shouldReturnError:Bool
    
    init(shouldReturnError:Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    var error:Error!
    
    var menCategories = [
        "products": [
            [
                "id": 6687366643910,
                "title": "NIKE | CRACKLE PRINT TB TEE",
                "body_html": "Meet your new favorite tee, the Nike Crackle Print T-Shirt. Bringing its A-game in soft, premium fabric, it features a ribbed crew neck and a woven Nike label on the hem.",
                "vendor": "NIKE",
                "product_type": "T-SHIRTS",
                "created_at": "2021-05-17T23:49:43+02:00",
                "handle": "nike-crackle-print-tb-tee",
                "updated_at": "2021-06-19T21:30:40+02:00",
                "published_at": "2021-05-17T23:49:43+02:00",
                "template_suffix": nil,
                "status": "active",
                "published_scope": "web",
                "tags": "egnition-sample-data, men, nike, summer",
                "admin_graphql_api_id": "gid://shopify/Product/6687366643910",
                "options": [
                    [
                        "id": 8585097609414,
                        "product_id": 6687366643910,
                        "name": "Size",
                        "position": 1
                    ],
                    [
                        "id": 8585097642182,
                        "product_id": 6687366643910,
                        "name": "Color",
                        "position": 2
                    ]
                ],
                "images": [
                    [
                        "id": 29002667884742,
                        "product_id": 6687366643910,
                        "position": 1,
                        "created_at": "2021-05-17T23:49:43+02:00",
                        "updated_at": "2021-05-17T23:49:43+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/62a3dd0421fc5ccf4df6815b3694d734.jpg?v=1621288183",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002667884742"
                    ],
                    [
                        "id": 29002667917510,
                        "product_id": 6687366643910,
                        "position": 2,
                        "created_at": "2021-05-17T23:49:43+02:00",
                        "updated_at": "2021-05-17T23:49:43+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/ef0746b3c879000196dfce266154b537.jpg?v=1621288183",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002667917510"
                    ],
                    [
                        "id": 29002667950278,
                        "product_id": 6687366643910,
                        "position": 3,
                        "created_at": "2021-05-17T23:49:43+02:00",
                        "updated_at": "2021-05-17T23:49:43+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/544c0236ac6a8def363f3db689aacf08.jpg?v=1621288183",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002667950278"
                    ]
                ],
                "image": [
                    "id": 29002667884742,
                    "product_id": 6687366643910,
                    "position": 1,
                    "created_at": "2021-05-17T23:49:43+02:00",
                    "updated_at": "2021-05-17T23:49:43+02:00",
                    "alt": nil,
                    "width": 635,
                    "height": 560,
                    "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/62a3dd0421fc5ccf4df6815b3694d734.jpg?v=1621288183",
                    "variant_ids": [],
                    "admin_graphql_api_id": "gid://shopify/ProductImage/29002667884742"
                ]
            ],
            [
                "id": 6687366217926,
                "title": "ADIDAS | SUPERSTAR 80S",
                "body_html": "There's a shell toe for every season, and the adidas Originals Superstar 80s shoes have a full grain leather upper with a shiny badge on the tongue that makes these shoes ready for any time of year.",
                "vendor": "ADIDAS",
                "product_type": "SHOES",
                "created_at": "2021-05-17T23:49:23+02:00",
                "handle": "adidas-superstar-80s",
                "updated_at": "2021-06-19T19:00:59+02:00",
                "published_at": "2021-05-17T23:49:23+02:00",
                "template_suffix": nil,
                "status": "active",
                "published_scope": "web",
                "tags": "adidas, autumn, egnition-sample-data, men, spring, summer",
                "admin_graphql_api_id": "gid://shopify/Product/6687366217926",
                "options": [
                    [
                        "id": 8585096986822,
                        "product_id": 6687366217926,
                        "name": "Size",
                        "position": 1
                    ],
                    [
                        "id": 8585097019590,
                        "product_id": 6687366217926,
                        "name": "Color",
                        "position": 2
                    ]
                ],
                "images": [
                    [
                        "id": 29002663362758,
                        "product_id": 6687366217926,
                        "position": 1,
                        "created_at": "2021-05-17T23:49:23+02:00",
                        "updated_at": "2021-05-17T23:49:23+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/44694ee386818f3276566210464cf341.jpg?v=1621288163",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002663362758"
                    ],
                    [
                        "id": 29002663395526,
                        "product_id": 6687366217926,
                        "position": 2,
                        "created_at": "2021-05-17T23:49:23+02:00",
                        "updated_at": "2021-05-17T23:49:23+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/b5176e5151cdf20d15cff3f551274753.jpg?v=1621288163",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002663395526"
                    ],
                    [
                        "id": 29002663428294,
                        "product_id": 6687366217926,
                        "position": 3,
                        "created_at": "2021-05-17T23:49:23+02:00",
                        "updated_at": "2021-05-17T23:49:23+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/6eb0aa9fdb271e5954b2f0d09a0640e4.jpg?v=1621288163",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002663428294"
                    ],
                    [
                        "id": 29002663461062,
                        "product_id": 6687366217926,
                        "position": 4,
                        "created_at": "2021-05-17T23:49:23+02:00",
                        "updated_at": "2021-05-17T23:49:23+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/015219de8a5be46a3b0a7b9089112d74.jpg?v=1621288163",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002663461062"
                    ],
                    [
                        "id": 29002663493830,
                        "product_id": 6687366217926,
                        "position": 5,
                        "created_at": "2021-05-17T23:49:23+02:00",
                        "updated_at": "2021-05-17T23:49:23+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/e8490702c423e6c62d356cace500822f.jpg?v=1621288163",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002663493830"
                    ]
                ],
                "image": [
                    "id": 29002663362758,
                    "product_id": 6687366217926,
                    "position": 1,
                    "created_at": "2021-05-17T23:49:23+02:00",
                    "updated_at": "2021-05-17T23:49:23+02:00",
                    "alt": nil,
                    "width": 635,
                    "height": 560,
                    "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/44694ee386818f3276566210464cf341.jpg?v=1621288163",
                    "variant_ids": [],
                    "admin_graphql_api_id": "gid://shopify/ProductImage/29002663362758"
                ]
            ]
        ]
    ]
    
    enum ErrorHandler : Error {
        case returnError
    }
    
}


extension MockCategoryAPI : CategoryAPIContract {
    func getCategoryProducts(catType: String, completion: @escaping (Result<ProductModels?, NSError>) -> Void) {
        var allCategories = ProductModels(products: [])
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: menCategories, options: .fragmentsAllowed)
            allCategories = try JSONDecoder().decode(ProductModels.self, from: jsonData)

        }catch let error{
            print(error.localizedDescription)
        }
        
        if shouldReturnError{
            completion(.failure(error! as NSError))
        }else{
            completion(.success(allCategories))
        }

        
    }
}
