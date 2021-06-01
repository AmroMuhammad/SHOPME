////
////  LogIn.swift
////  Shopify e-commerce
////
////  Created by Ayman Omara on 30/05/2021.
////  Copyright © 2021 ITI41. All rights reserved.
//
//
//import Foundation
//
//// MARK: - Customer
struct Customer: Codable {
    let customers: [CustomerElement]
}
//
//// MARK: - CustomerElement
struct CustomerElement: Codable {
    let id: Int
    let email:String?
    let lastOrderID: Int?
    let first_name, last_name, total_spent: String?
    //let note: String?
    //let verified_email, tax_exempt: Bool?
    //let phone: Int?
    //let tags, last_order_name, currency: String?
    
//}
//    enum CodingKeys: String, CodingKey {
//
//
//        case id, email
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case totalSpent = "total_spent"
//        case lastOrderID = "last_order_id"
//        case note
//        case verifiedEmail = "verified_email"
//        case taxExempt = "tax_exempt"
//        case phone, tags
//        case lastOrderName = "last_order_name"
//        case currency, addresses
//   }
}
//
//
////// MARK: - Address
//struct Address: Codable {
//    let address1, city, province, phone: String
//    let zip, lastName, firstName, country: String
//
//    enum CodingKeys: String, CodingKey {
//        case address1, city, province, phone, zip
//        case lastName = "last_name"
//        case firstName = "first_name"
//        case country
//    }
//}
