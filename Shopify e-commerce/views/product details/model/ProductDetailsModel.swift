//
//  ProductModel.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 03/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation

struct ProductDetailsModel: Codable {
    
    let product: ProductDetails
}

struct ProductDetails: Codable {
    
    let id: Int     //Int64
    let title: String?
    let vendor: String?          // ???
    let product_type: String?    // ???
    let handle: String?
    let status: String?
    let tags: String?
    let variants: [ProductDetailsVariants]?
    let options: [ProductDetailsOptions]?
    let images: [ProductDetailsImage]?
    let image: ProductDetailsImage?
    
}

struct ProductDetailsVariants: Codable {
    
    let id: Int  //Int64        // ???
    let product_id: Int?     // ???
    let price: String?
}

struct ProductDetailsOptions: Codable {
    
    let id: Int  //Int64        // ???
    let product_id: Int?     // ???
    let name: String?
    let values: [String]?
}


struct ProductDetailsImage: Codable {
    
    let id: Int  //Int64        // ???
//    let product_id: Int?     // ???
    let src: String?
}
