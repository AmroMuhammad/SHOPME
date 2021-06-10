//
//  RegisterCustomer.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 04/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.

import Foundation
struct RegisterCustomer: Codable {
    let customer: Customer
}

struct Customer: Codable {
    let id: Int?
    let email, firstName, lastName, phone: String?
    let tags: String?
    let addresses: [Address?]?

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case addresses
        case phone, tags
    }
}

// MARK: - Address
struct Address: Codable {
    let id, customerID: Int?
    let city,country: String?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case city, country
    }
}
