//
//  MeViewModel.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 05/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
class MeViewModel{
    var api:ShopifyAPI!
    var userData:UserData!
    var support = Support()
    var customer:[CustomerElement]!{
        didSet{
            self.bindCustomerToView()
        }
        
    }
    
    var  bindCustomerToView:(()->()) = {}
    var  bindErrorToView:(()->()) = {}
    
    
    var registrationError:String!{
        
        didSet{
            
        }
    }
    var errorMessage:String!{
        
        didSet{
            self.bindErrorToView()
        }
    }
    init() {
        api = ShopifyAPI.shared
        userData = UserData.getInstance()
        self.featchCustomerData()
    }
    
    
    func featchCustomerData(){
        api.getCustomers { (result) in
            switch(result){
            case .success(let response):
                let customers = response
                print(customers!.customers)
                self.customer = customers?.customers
                
            case .failure(let error):
                print("error")
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func checkUserName_Password(email:String,password:String,context:UIViewController,array:[CustomerElement]) -> Void {
        if email != "" && password != "" {
            self.checkIsCustomerexist(email: email, password: password,array:array,context:context)
        }
        else{
            support.notifyUser(title: Constants.u_p_required_t, body: Constants.u_p_required_t, context: context.self)
        }
    }
    func checkIsCustomerexist(email:String,password:String,array:[CustomerElement],context:UIViewController)->Void{
        for customer in array{
            if customer.email == email && customer.tags == password {
                userData.saveUserDefaults(email: customer.email!, id: customer.id!)
                let mytuble = userData.userStatus()
                print(mytuble.0)
                print("===============================================")
                print(mytuble.1)
                print(userData.userStatus())
                support.notifyUser(title: Constants.loginSuccess, body: Constants.loginSuccess, context: context.self)
                
                
            }
            else{
                support.notifyUser(title: Constants.wrongEmail_Pass, body: Constants.empty, context: context.self)
            }
        }
        
    }
    
    
    
    
    
    
    
    // MARK:- Registartion part
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validateRegisterdData(first:String,last:String,phone:String,password:String,secPass:String,email:String,country:String,city:String,context:UIViewController) -> Void {
        
        if(first != "" && last != "" && email != "" && phone != "" && password != "" && secPass != "" && password == secPass && isValidEmail(email) && city != "" && country != ""){
            var d:[DefaultAddress]  = [DefaultAddress]()
            var abc = DefaultAddress()
            //abc.city = self.city.text!
           // d[0].city = self.city.text!
            //abc.country = self.country.text!
            //d.append(abc)
            var customerElement = CustomerRegister(email:"aymanomara55@gmail.com", first_name:first,last_name:last,tags: "",phone: "",id:234,note: "1234", address: d)
            customerElement.email = email
            customerElement.first_name = first
            customerElement.last_name = last
            customerElement.phone = phone
            customerElement.tags = password
            
            let cust = RegisterCustomer(customer: customerElement)
            api.addNewCustomer(customer: cust)
            
            
            if(ShopifyAPI.statusCodeForRegistration == 201){
                support.notifyUser(title: Constants.registerdSuccess, body: Constants.empty, context: context.self)
            }
            //            else if(ShopifyAPI.statusCodeForRegistration == 422){
            //                support.notifyUser(title: Constants.accountExisted, body: Constants.empty, context: self)
            //
            //            }
        }
        else if(first != "" || last != "" || email != "" || phone != "" || password != "" || secPass != "" || password != secPass || !isValidEmail(email)){
            
            if(password != secPass){
                
                support.notifyUser(title: Constants.pass_conf, body: Constants.empty, context: context.self)
            }else if(!isValidEmail(email)){
                support.notifyUser(title: Constants.emailIsnotValid_T, body: Constants.emailIsnotValid_B, context:context.self)
            }
            else{
                support.notifyUser(title: Constants.allfeildReq, body: Constants.empty, context: context.self)
            }
        }
        else{
            support.notifyUser(title: Constants.faildBody, body: Constants.empty, context: context.self)
        }
        
    }
}
