//
//  ProductModel.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 03/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation

struct ProductModel: Codable {
    
    let product: Product
}

struct Product: Codable {
    
    let id: Int     //Int64
    let title: String?
    let vendor: String?          // ???
    let product_type: String?    // ???
    let handle: String?
    let status: String?
    let tags: String?
    let variants: [ProductVariants]?
    let options: [ProductOptions]?
    let images: [ProductImage]?
    let image: ProductImage?
    
}

struct ProductVariants: Codable {
    
    let id: Int  //Int64        // ???
    let product_id: Int?     // ???
    let price: String?
}

struct ProductOptions: Codable {
    
    let id: Int  //Int64        // ???
    let product_id: Int?     // ???
    let name: String?
    let values: [String]?
}


struct ProductImage: Codable {
    
    let id: Int  //Int64        // ???
//    let product_id: Int?     // ???
    let src: String?
}
