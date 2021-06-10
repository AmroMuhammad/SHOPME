//
//  RegisterCustomer.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 04/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.

import Foundation
struct RegisterCustomer:Codable {
    var customer:CustomerRegister?
}
struct CustomerRegister:Codable {
    var email:String?
    var first_name, last_name, tags, phone: String?
    var id:Int?
    var note:String?
    var address:[DefaultAddress]?
}
struct DefaultAddress:Codable {
    var city:String?
    var country:String?
    var customer_id:Int?
    var first_name:String?
    var last_name:String?
    var company:String?
    var address1:String?
    var address2:String?
    var province: String?
    var zip:String?
    var phone : String?
    var name: String?
    var province_code:String?
    var country_code: String?
    var country_name: String?
}
