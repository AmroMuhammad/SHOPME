//
//  RegisterViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 30/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    let api = ShopifyAPI.shared
    var customerElement = CustomerRegister(email:"aymanomara55@gmail.com", first_name:"ayman",last_name:"omara")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        customerElement.email = "aymanomara55@gmail.com"
        customerElement.first_name = "ayman"
        customerElement.last_name = "omara"
        var cust = RegisterCustomer(customer: customerElement)
        api.addNewCustomer(customer: cust)

    }
    



}
