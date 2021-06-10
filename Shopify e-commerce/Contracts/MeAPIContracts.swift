//
//  MeAPIContracts.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/10/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
protocol RegisterAPIContract {
    func addCustomer(customerData:RegisterCustomer,completion: @escaping (Result<RegisterCustomer?,NSError>) -> Void)
}
