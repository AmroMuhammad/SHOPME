//
//  RegisterCustomer.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 04/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
struct RegisterCustomer:Encodable {
    var customer:CustomerRegister
}
struct CustomerRegister:Encodable {
    var email:String
    var first_name, last_name, tags, phone: String
    var id:Int
    var note:String
    var address:[DefaultAddress]
    
}
struct DefaultAddress:Codable {
    var city:String?
    var country:String?
}
