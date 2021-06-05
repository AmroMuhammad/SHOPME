//  RegisterViewController.swift
//  Shopify e-commerce
//  Created by Ayman Omara on 30/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
import UIKit

class RegisterViewController: UIViewController {
    
    let api = ShopifyAPI.shared
    var support = Support()
    
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var secondName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var confPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var meViewModel = MeViewModel();
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
//    func putRequest() -> Void {
//        var d:[DefaultAddress]  = [DefaultAddress]()
//        d[0].city = city.text!
//        d[0].country = country.text!
//        var customerElement = CustomerRegister(email:"aymanomara55@gmail.com", first_name:"first",last_name:"last",tags: "",phone: "",id:234,note: "1234", address: d)
//
//        //customerElement.email = "s.lastnameson@example.com"
//        customerElement.id = 5246397874374
//        //customerElement.phone = "0900000000"
//        customerElement.note = "438723874874378847"
//
//
//        let cust = RegisterCustomer(customer: customerElement)
//
//        api.editCustomer(customer: cust)
//    }
    
    
    @IBAction func submit(_ sender: Any) {
        meViewModel.validateRegisterdData(first: firstName.text!, last:secondName.text!, phone: phoneNumber.text!, password: password.text!, secPass: confPassword.text!, email: email.text!,country: country.text!,city: city.text!, context: self)

        
    }
    
}
