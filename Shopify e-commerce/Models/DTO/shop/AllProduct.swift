//
//  AllProduct.swift
//  Shopify e-commerce
//
//  Created by marwa on 5/26/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
struct AllProduct: Codable {
    let product: [Product]
}
struct Product: Codable {
    let id: Int
    let title, bodyHTML, vendor, productType: String
    let createdAt: Date
    let handle: String
    let updatedAt, publishedAt: Date
    let publishedScope, tags, adminGraphqlAPIID: String
    let options: [Option]
    let images: [Image]
    let image: Image

    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case publishedScope = "published_scope"
        case tags
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case options, images, image
    }
}

// MARK: - Image
struct Image: Codable {
    let id, productID, position: Int
    let createdAt, updatedAt: Date
    let width, height: Int
    let src: String
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, src
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}

// MARK: - Option
struct Option: Codable {
    let id, productID: Int
    let name: String
    let position: Int

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position
    }
}

