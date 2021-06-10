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
    init() {
        //Ayman
        api = ShopifyAPI.shared
        userData = UserData.getInstance()
        self.featchCustomerData()
    }
    
    
    
    
    
    var api:ShopifyAPI!
    var userData:UserData!
    var support = Support()
    var userEmailObservable:Observable<String>?
    var isLogedInObservable:Observable<Bool>?
    
    
    var customer:[CustomerElement]!{
        didSet{
            self.bindCustomerToView()
        }
        
    }
    var bindCustomerName:(()->()) = {}
    var  bindCustomerToView:(()->()) = {}
    var  bindErrorToView:(()->()) = {}
    
    
    var errorMessage:String!{
        
        didSet{
            self.bindErrorToView()
        }
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
    //    func checkUserName_Password(email:String,password:String,context:UIViewController,array:[CustomerElement]) -> Void {
    //        if email != "" && password != "" {
    //            self.checkIsCustomerexist(email: email, password: password,array:array,context:context)
    //        }
    //        else{
    //            Support.notifyUser(title: Constants.u_p_required_t, body: Constants.u_p_required_t, context: context.self)
    //        }
    //    }
    func signOutUser() -> Void {
        userData.deleteUserDefaults()
    }
    func logedInAlert(context:UIViewController) -> Void {
        let SucssesAlert = UIAlertController(title: "Log In success", message: "", preferredStyle: UIAlertController.Style.alert)
        SucssesAlert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        context.present(SucssesAlert, animated: true, completion: nil)
    }
    
    func checkIsCustomerexist(email:String,password:String,array:[CustomerElement],context:UIViewController,welcome:UILabel,signInOutlet: UIView,emailTextField: UITextField,passwordTextField: UITextField)->Void{
        print(userData.userStatus())
        //userData.saveUserDefaults(email: "assmaa", id: 0)
        if email == "" || password == "" {
            Support.notifyUser(title: Constants.u_p_required_t, body: Constants.u_p_required_t, context: context.self)
        }
        else{
            for customer in customer{
                if customer.email == email && customer.tags == password {
                    userData.saveUserDefaults(email: customer.email!, id: customer.id!)
                    welcome.alpha = 1
                    signInOutlet.alpha = 0
                    welcome.text! = userData.userStatus().0
                    emailTextField.text! = ""
                    passwordTextField.text! = ""
                    userEmailObservable = Observable<String>.just(userData.userStatus().0)
                    self.logedInAlert(context: context)
                    print(userData.userStatus())
                    
                }
                else{
                    // IF USER NAME AND PASSOWRD IS INCORRECT
                }
                
            }
        }
    }
    
    
    // MARK:- Registartion part
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func registerDoneAlert(context:UIViewController) -> Void {
        let registerDoneAlert = UIAlertController(title: "registerd Succesfully", message: "", preferredStyle: UIAlertController.Style.alert)
        registerDoneAlert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        context.present(registerDoneAlert, animated: true, completion: nil)
    }
    
    func accountIsAlreadyExist(context:UIViewController) -> Void {
        let accountIsAlreadyExist = UIAlertController(title: "account Already Exist", message: "", preferredStyle: UIAlertController.Style.alert)
        accountIsAlreadyExist.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        context.present(accountIsAlreadyExist, animated: true, completion: nil)
    }
    func errorTryAgainLater(context:UIViewController) -> Void {
        let errorTryAgainLater = UIAlertController(title: "error please try agin later", message: "", preferredStyle: UIAlertController.Style.alert)
        errorTryAgainLater.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        context.present(errorTryAgainLater, animated: true, completion: nil)
    }
    
//        if(first != "" && last != "" && email != "" && phone != "" && password != "" && secPass != "" && password == secPass && isValidEmail(email) && city != "" && country != ""){
//
//            var customerElement = CustomerRegister()
//            customerElement.email = email
//            customerElement.first_name = first
//            customerElement.last_name = last
//            customerElement.phone = phone
//            customerElement.tags = password
//
//            let cust = RegisterCustomer()
//            //cust.customer = customerElement
//            api.addNewCustomer(customer: cust) { (statusCode) in
//                print("==========================================================================user customer clouser")
//                print(statusCode)
//                if(statusCode == 201){
//                    print("=================== inside the clouser and the status code is 201")
//
//                    self.userData.saveUserDefaults(email: (cust.customer?.email)!, id: 0)
//
//                    DispatchQueue.main.sync {
//                        cityTextField.text! = ""
//                        confPassword.text! = ""
//                        secondTF.text! = ""
//                        firstTF.text! = ""
//                        phoneNumberTF.text! = ""
//                        countryTF.text! = ""
//                        emailTF.text! = ""
//                        passwordTF.text! = ""
//                        self.registerDoneAlert(context: context.self)
//
//
//
//                    }
//                }else if(statusCode == 422){
//                    DispatchQueue.main.sync {
//                        self.accountIsAlreadyExist(context: context.self)
//                    }
//                }
//
//                else{
//                    print(statusCode)
//                    DispatchQueue.main.sync {
//                        self.errorTryAgainLater(context: context.self)
//                    }
//                }
//            }
//        }
//        else if(first != "" || last != "" || email != "" || phone != "" || password != "" || secPass != "" || password != secPass || !isValidEmail(email)){
//
//            if(password != secPass){
//
//                Support.notifyUser(title: Constants.pass_conf, body: Constants.empty, context: context.self)
//            }else if(!isValidEmail(email)){
//                Support.notifyUser(title: Constants.emailIsnotValid_T, body: Constants.emailIsnotValid_B, context:context.self)
//            }
//            else{
//                Support.notifyUser(title: Constants.allfeildReq, body: Constants.empty, context: context.self)
//            }
//        }
//        else{
//            Support.notifyUser(title: Constants.faildBody, body: Constants.empty, context: context.self)
//        }
        
//    }
}
