//
//  EditIngViewController.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 08/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class EditIngViewController: UIViewController {
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var secondName: UITextField!
    
    
    @IBOutlet weak var email: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confermationPassword: UITextField!
    
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var countrry: UITextField!
    
    
    @IBOutlet weak var city: UITextField!
    
    
    
    var api = ShopifyAPI.shared
    var userData = UserData.getInstance().userStatus()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func submit(_ sender: UIButton) {
//        print("inside the btn action of edit")
//        var registerCustomer = RegisterCustomer()
//        var customer = CustomerRegister()
//        customer.id = userData.2
//        //customer.id = userData.2
//        customer.email = email.text!
//        //registerCustomer.customer?.phone = phoneNumber.text!
//        customer.first_name = firstName.text!
//        customer.last_name = secondName.text!
//        //if(password.text! == confermationPassword.text!){
//        registerCustomer.customer?.tags = password.text!
//        registerCustomer.customer = customer
//        print(customer.email)
//        print(registerCustomer.customer?.email)
//        print(customer.id)
//        print(registerCustomer.customer?.id)
//        print(customer.first_name)
//        print(registerCustomer.customer?.first_name)
//        
//        //}
//        //registerCustomer.customer?.address
//         api.editCustomer(customer: registerCustomer, id: userData.2)

    }
    

}
