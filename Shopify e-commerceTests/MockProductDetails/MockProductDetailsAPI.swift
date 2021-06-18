//
//  MockProductDetailsAPI.swift
//  Shopify e-commerceTests
//
//  Created by Ahmd Amr on 18/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation

class MockProductDetails {

    var shouldReturnError: Bool!
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    let mockProductJSONResponse: [String: [[String: Any?]]] =
        [
        "product": [
                "id": 6687365890246,
                "title": "ASICS TIGER | GEL-LYTE V '30 YEARS OF GEL' PACK",
                "body_html": "The iconic ASICS Tiger GEL-Lyte III was originally released in 1990. Having over two decades of performance heritage, it offers fine design detailing and a padded split tongue to eliminate tongue movement, built on a sleek silhouette. It comes as no surprise the Gel-Lyte III is a fast growing popular choice for sneaker enthusiasts all over the world.",
                "vendor": "ASICS TIGER",
                "product_type": "SHOES",
                "created_at": "2021-05-17T23:49:13+02:00",
                "handle": "asics-tiger-gel-lyte-v-30-years-of-gel-pack",
                "updated_at": "2021-06-17T13:35:36+02:00",
                "published_at": "2021-05-17T23:49:13+02:00",
                "template_suffix": nil,
                "status": "active",
                "published_scope": "web",
                "tags": "asics-tiger, autumn, egnition-sample-data, men, spring",
                "admin_graphql_api_id": "gid://shopify/Product/6687365890246",
                "variants": [
                    [
                        "id": 39853305954502,
                        "product_id": 6687365890246,
                        "title": "4 / black",
                        "price": "220.00",
                        "sku": "AsTi-01-black-4",
                        "position": 1,
                        "inventory_policy": "deny",
                        "compare_at_price": nil,
                        "fulfillment_service": "manual",
                        "inventory_management": "shopify",
                        "option1": "4",
                        "option2": "black",
                        "option3": nil,
                        "created_at": "2021-05-17T23:49:13+02:00",
                        "updated_at": "2021-05-17T23:50:41+02:00",
                        "taxable": true,
                        "barcode": nil,
                        "grams": 0,
                        "image_id": nil,
                        "weight": 0.0,
                        "weight_unit": "kg",
                        "inventory_item_id": 41947926560966,
                        "inventory_quantity": 1,
                        "old_inventory_quantity": 1,
                        "requires_shipping": true,
                        "admin_graphql_api_id": "gid://shopify/ProductVariant/39853305954502"
                    ],
                    [
                        "id": 39853305987270,
                        "product_id": 6687365890246,
                        "title": "8 / black",
                        "price": "220.00",
                        "sku": "AsTi-01-black-8",
                        "position": 2,
                        "inventory_policy": "deny",
                        "compare_at_price": nil,
                        "fulfillment_service": "manual",
                        "inventory_management": "shopify",
                        "option1": "8",
                        "option2": "black",
                        "option3": nil,
                        "created_at": "2021-05-17T23:49:13+02:00",
                        "updated_at": "2021-05-17T23:50:40+02:00",
                        "taxable": true,
                        "barcode": nil,
                        "grams": 0,
                        "image_id": nil,
                        "weight": 0.0,
                        "weight_unit": "kg",
                        "inventory_item_id": 41947926593734,
                        "inventory_quantity": 13,
                        "old_inventory_quantity": 13,
                        "requires_shipping": true,
                        "admin_graphql_api_id": "gid://shopify/ProductVariant/39853305987270"
                    ],
                    [
                        "id": 39853306020038,
                        "product_id": 6687365890246,
                        "title": "14 / black",
                        "price": "220.00",
                        "sku": "AsTi-01-black-14",
                        "position": 3,
                        "inventory_policy": "deny",
                        "compare_at_price": nil,
                        "fulfillment_service": "manual",
                        "inventory_management": "shopify",
                        "option1": "14",
                        "option2": "black",
                        "option3": nil,
                        "created_at": "2021-05-17T23:49:13+02:00",
                        "updated_at": "2021-05-17T23:50:40+02:00",
                        "taxable": true,
                        "barcode": nil,
                        "grams": 0,
                        "image_id": nil,
                        "weight": 0.0,
                        "weight_unit": "kg",
                        "inventory_item_id": 41947926626502,
                        "inventory_quantity": 6,
                        "old_inventory_quantity": 6,
                        "requires_shipping": true,
                        "admin_graphql_api_id": "gid://shopify/ProductVariant/39853306020038"
                    ]
                ],
                "options": [
                    [
                        "id": 8585096560838,
                        "product_id": 6687365890246,
                        "name": "Size",
                        "position": 1,
                        "values": [
                            "4",
                            "8",
                            "14"
                        ]
                    ],
                    [
                        "id": 8585096593606,
                        "product_id": 6687365890246,
                        "name": "Color",
                        "position": 2,
                        "values": [
                            "black"
                        ]
                    ]
                ],
                "images": [
                    [
                        "id": 29002660217030,
                        "product_id": 6687365890246,
                        "position": 1,
                        "created_at": "2021-05-17T23:49:13+02:00",
                        "updated_at": "2021-05-17T23:49:13+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/343bfbfc1a10a39a528a3d34367669c2.jpg?v=1621288153",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002660217030"
                    ],
                    [
                        "id": 29002660249798,
                        "product_id": 6687365890246,
                        "position": 2,
                        "created_at": "2021-05-17T23:49:13+02:00",
                        "updated_at": "2021-05-17T23:49:13+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/548e71e82d4b2d3bdd2b739b4872edc9.jpg?v=1621288153",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002660249798"
                    ],
                    [
                        "id": 29002660282566,
                        "product_id": 6687365890246,
                        "position": 3,
                        "created_at": "2021-05-17T23:49:13+02:00",
                        "updated_at": "2021-05-17T23:49:13+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/92b18b29e25d47479716de9da45c6f11.jpg?v=1621288153",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002660282566"
                    ],
                    [
                        "id": 29002660315334,
                        "product_id": 6687365890246,
                        "position": 4,
                        "created_at": "2021-05-17T23:49:13+02:00",
                        "updated_at": "2021-05-17T23:49:13+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/849cb34b82473241efdfcf60f9106452.jpg?v=1621288153",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002660315334"
                    ],
                    [
                        "id": 29002660348102,
                        "product_id": 6687365890246,
                        "position": 5,
                        "created_at": "2021-05-17T23:49:13+02:00",
                        "updated_at": "2021-05-17T23:49:13+02:00",
                        "alt": nil,
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/262cb366636c10febf8b843a1d0853c5.jpg?v=1621288153",
                        "variant_ids": [],
                        "admin_graphql_api_id": "gid://shopify/ProductImage/29002660348102"
                    ]
                ],
                "image": [
                    "id": 29002660217030,
                    "product_id": 6687365890246,
                    "position": 1,
                    "created_at": "2021-05-17T23:49:13+02:00",
                    "updated_at": "2021-05-17T23:49:13+02:00",
                    "alt": nil,
                    "width": 635,
                    "height": 560,
                    "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/343bfbfc1a10a39a528a3d34367669c2.jpg?v=1621288153",
                    "variant_ids": [],
                    "admin_graphql_api_id": "gid://shopify/ProductImage/29002660217030"
                ]
            ]
        ]

}

enum ResponseError: Error {
    case responseWaitError
}


