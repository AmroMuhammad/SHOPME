//  RegisterViewController.swift
//  Shopify e-commerce
//  Created by Ayman Omara on 30/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
import UIKit

class RegisterViewController: UIViewController {
    let api = ShopifyAPI.shared
    var support = Support()
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var secondName: UITextField!
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    @IBOutlet weak var confPassword: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var customerElement = CustomerRegister(email:"aymanomara55@gmail.com", first_name:"first",last_name:"last",tags: "",phone: "",id:234,note: "1234")
        
        //customerElement.email = "s.lastnameson@example.com"
        customerElement.id = 5246397874374
        //customerElement.phone = "0900000000"
        customerElement.note = "438723874874378847"

        
        let cust = RegisterCustomer(customer: customerElement)
            //api.addNewCustomer(customer: cust)
        api.editCustomer(customer: cust)
        
        
    }
    func validateRegisterdData(first:String,last:String,phone:String,password:String,secPass:String,email:String) -> Void {
        
        if(first != "" && last != "" && email != "" && phone != "" && password != "" && secPass != "" && password == secPass){
            
            var customerElement = CustomerRegister(email:"aymanomara55@gmail.com", first_name:first,last_name:last,tags: "",phone: "",id:234,note: "1234")
            customerElement.email = email
            customerElement.first_name = first
            customerElement.last_name = last
            customerElement.phone = phone
            customerElement.tags = password
            
            let cust = RegisterCustomer(customer: customerElement)
            api.addNewCustomer(customer: cust)
            
            
            if(ShopifyAPI.statusCode == 201){
                support.notifyUser(title: Constants.registerdSuccess, body: Constants.empty, context: self)
            }
            else if(ShopifyAPI.statusCode == 422){
                support.notifyUser(title: Constants.accountExisted, body: Constants.empty, context: self)
            }
        }
        else if(first != "" || last != "" || email != "" || phone != "" || password != "" || secPass != "" || password != secPass){
            
            if(password != secPass){
                
                support.notifyUser(title: Constants.pass_conf, body: Constants.empty, context: self)
            }else{
                support.notifyUser(title: Constants.allfeildReq, body: Constants.empty, context: self)
            }
        }
        else{
            support.notifyUser(title: Constants.faildBody, body: Constants.empty, context: self)
        }
        
    }
    
    
    
    @IBAction func submit(_ sender: Any) {
        self.validateRegisterdData(first: firstName.text!, last:secondName.text!, phone: phoneNumber.text!, password: password.text!, secPass: confPassword.text!, email: email.text!)
        
    }
    
}
