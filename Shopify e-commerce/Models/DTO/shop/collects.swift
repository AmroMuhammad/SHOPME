//
//  collects.swift
//  Shopify e-commerce
//
//  Created by marwa on 5/27/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation

struct Collects: Codable {
    let collects: [Collect]
}

// MARK: - Collect
struct Collect: Codable {
    let id: Int64
    let collection_id: Int64
    let product_id: Int64
    let created_at, updated_at: String?
    let position: Int64
    let sort_value: String

}
