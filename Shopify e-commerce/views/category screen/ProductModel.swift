//
//  ProductModel.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/1/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation

// MARK: - ProductModel
struct ProductModel: Codable {
    let products: [CategoryProduct]
}

// MARK: - Product
struct CategoryProduct: Codable {
    let id: Int
//    let title, bodyHTML, vendor, productType: String
//    let createdAt: Date
//    let handle: String
//    let updatedAt, publishedAt: Date
//    let publishedScope, tags, adminGraphqlAPIID: String
//    let options: [ProductOption]
//    let images: [ProductImage]
//    let image: ProductImage

//    enum CodingKeys: String, CodingKey {
//        case id, title
//        case bodyHTML = "body_html"
//        case vendor
//        case productType = "product_type"
//        case createdAt = "created_at"
//        case handle
//        case updatedAt = "updated_at"
//        case publishedAt = "published_at"
//        case publishedScope = "published_scope"
//        case tags
//        case adminGraphqlAPIID = "admin_graphql_api_id"
//        case options, images, image
//    }
}

// MARK: - Image
//struct ProductImage: Codable {
//    let id, productID, position: Int
//    let createdAt, updatedAt: Date
//    let width, height: Int
//    let src: String
//    let variantIDS: [Int]
//    let adminGraphqlAPIID: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productID = "product_id"
//        case position
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case width, height, src
//        case variantIDS = "variant_ids"
//        case adminGraphqlAPIID = "admin_graphql_api_id"
//    }
//}
//
//// MARK: - Option
//struct ProductOption: Codable {
//    let id, productID: Int
//    let name: String
//    let position: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productID = "product_id"
//        case name, position
//    }
//}
