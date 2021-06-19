//
//  RegisterViewModel.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/10/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import TKFormTextField

class RegisterViewModel:RegisterViewModelContract{    
    private var errorSubject = PublishSubject<(String,Bool)>()
    private var loadingsubject = PublishSubject<Bool>()
    private var doneSubject = PublishSubject<Bool>()
    private var data:Customer!
    private var shopifyAPI:RegisterAPIContract!
    private var userData:UserData
    
    var errorObservable: Observable<(String, Bool)>
    var loadingObservable: Observable<Bool>
    var doneObservable: Observable<Bool>

    init() {
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        doneObservable = doneSubject.asObservable()
        
        shopifyAPI = ShopifyAPI.shared
        userData = UserData.sharedInstance
    }
    
    func postData(newCustomer:RegisterCustomer){
        loadingsubject.onNext(true)
        shopifyAPI.addCustomer(customerData: newCustomer) {[weak self] (result) in
            switch result{
            case .success(let customer):
                self?.loadingsubject.onNext(false)
                self?.data = customer?.customer
                print("=============================")
                print(customer)
                self?.userData.saveUserDefaults(customer: customer!.customer)
                //add to userDefaults
                self?.doneSubject.onCompleted()
            case .failure(let error):
                self?.loadingsubject.onNext(false)
                self?.errorSubject.onNext((error.localizedDescription, true))
            }
        }
        
    }
    
    @objc func countryError(textField: TKFormTextField) {
            //var phone = textField.text
            if(textField.text == ""){
                textField.error = "all fields are required"
            }
            else{
                textField.error = nil
            }
        
        }
        
        @objc func cityError(textField: TKFormTextField) {
            //var phone = textField.text
            if(textField.text == ""){
                textField.error = "all fields are required"
            }
            else{
                textField.error = nil
            }
        
        }
        
        
        @objc func updateError(textField: TKFormTextField) {
            //var phone = textField.text
            if(textField.text == ""){
                textField.error = "all fields are required"
            }
            else{
                textField.error = nil
            }
        
        }
        @objc func nameerror(textField: TKFormTextField) {
            //var phone = textField.text
            if(!nameRegexCheck(text: textField.text!)){
                textField.error = "please enter valid name"
            }
            else{
                textField.error = nil
            }
        }
        @objc func passerror(textField: TKFormTextField) {
            
    //        if(str1 != str2){
    //            textField.error = "password not equal confirmation password"
    //        }
    //        else{
    //            textField.error = nil
    //        }
        }
        @objc func phoneerror(textField: TKFormTextField) {
            
            if(!phoneNumRegexCheck(text: textField.text!)){
                textField.error = "please enter valid phone number"
            }
            else{
                textField.error = nil
            }
        }
            
            @objc func emailerror(textField: TKFormTextField) {
                //var phone = textField.text
                if(!emailRegexCheck(text: textField.text!)){
                    textField.error = "please enter valid email"
                }
                else{
                    textField.error = nil
                }
    //        guard let text = textField.text, !text.isEmpty else {
    //          textField.error = "Text is empty!" // to show error message in errorLabel
    //          return
    //        }
    //        textField.error = nil // to remove the error message
          }
    
//    func validateRegisterdData(firstName:String,lastName:String,email:String,phoneNumber:String,password:String,confirmPassword:String,country:String,city:String){
//
//        if(firstName.isEmpty || lastName.isEmpty || email.isEmpty || phoneNumber.isEmpty || password.isEmpty || confirmPassword.isEmpty || country.isEmpty || city.isEmpty){
//            errorSubject.onNext(("Please enter all fields", true))
//            return
//        }
//        if(!nameRegexCheck(text: firstName) || !nameRegexCheck(text: lastName)){
//            errorSubject.onNext(("Please enter valid First Name and Last Name", true))
//            return
//        }
//        if(!emailRegexCheck(text: email)){
//            errorSubject.onNext(("Please enter valid Email", true))
//            return
//        }
//        if(!phoneNumRegexCheck(text: phoneNumber)){
//            errorSubject.onNext(("Please enter valid phone number", true))
//            return
//        }
//        if(password.count <= 5){
//            errorSubject.onNext(("Confirm password is worng", true))
//            return
//        }else if(password != confirmPassword){
//            errorSubject.onNext(("password should be more than 5 characters", true))
//            return
//        }
//        if(!nameRegexCheck(text: country) || !nameRegexCheck(text: city)){
//            errorSubject.onNext(("Please enter valid country and city", true))
//            return
//        }
//        let newCustomer = RegisterCustomer(customer: Customer(id: nil, email: email, firstName: firstName, lastName: lastName, phone: "+2"+phoneNumber, tags: password,addresses: [Address(id: nil, customerID: nil, city: city, country: country)]))
//        postData(newCustomer: newCustomer)
//    }
    func validateRegisterdData(firstName:String,lastName:String,email:String,phoneNumber:String,password:String,confirmPassword:String,country:String,city:String,address:String,pn: TKFormTextField,context:UIViewController,fname: TKFormTextField,lname: TKFormTextField,em: TKFormTextField,count: TKFormTextField,cit: TKFormTextField,con:TKFormTextField,p:TKFormTextField,addressTxtField:TKFormTextField){
        
        
        
        if(firstName.isEmpty || lastName.isEmpty || email.isEmpty || phoneNumber.isEmpty || password.isEmpty || confirmPassword.isEmpty || country.isEmpty || city.isEmpty || address.isEmpty){
            em.error = "error"
           // pn.errorLabel.text = "please enter all"
          // pn.error = "please enter all"
            pn.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
            fname.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
            em.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
            lname.addTarget(self, action: #selector(updateError), for: .allEvents)
            count.addTarget(self, action: #selector(updateError), for: .allEvents)
            cit.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
            p.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
            con.addTarget(self, action: #selector(updateError), for: .editingDidEnd)
            addressTxtField.addTarget(self, action: #selector(updateError), for: .editingDidEnd)

          //  errorSubject.onNext(("Please enter all fields", true))
            return
        }
        if(!nameRegexCheck(text: firstName) || !nameRegexCheck(text: lastName)){
            lname.addTarget(self, action: #selector(nameerror), for: .allEvents)
            fname.addTarget(self, action: #selector(nameerror), for: .allEvents)
          //  errorSubject.onNext(("Please enter valid First Name and Last Name", true))
            //pn.addTarget(context, action: #selector(updateError), for: .editingChanged)
            return
        }
        if(!emailRegexCheck(text: email)){
            em.addTarget(self, action: #selector(emailerror), for: .allEvents)
            //errorSubject.onNext(("Please enter valid Email", true))
            return
        }
        if(!phoneNumRegexCheck(text: phoneNumber)){
            pn.addTarget(self, action: #selector(phoneerror), for: .allEvents)
            //errorSubject.onNext(("Please enter valid phone number", true))
            return
        }
        if(password.count <= 5){
            //errorSubject.onNext(("Confirm password is worng", true))
            return
        }else if(password != confirmPassword){
            p.addTarget(self, action: #selector(passerror), for: .allEvents)
            //errorSubject.onNext(("password should be more than 5 characters", true))
            return
        }
        if(!nameRegexCheck(text: country) || !nameRegexCheck(text: city)){
            count.addTarget(self, action: #selector(countryError), for: .allEvents)
            cit.addTarget(self, action: #selector(cityError), for: .allEvents)
            //errorSubject.onNext(("Please enter valid country and city", true))
            return
        }
        let newCustomer = RegisterCustomer(customer: Customer(id: nil, email: email, firstName: firstName, lastName: lastName, phone: "+2"+phoneNumber, tags: password,addresses: [Address(id: nil, customerID: nil, city: city, country: country, address1: address)]))
        postData(newCustomer: newCustomer)
    }
    
    func nameRegexCheck(text:String)-> Bool{
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[0-9]+")
        if(regex.firstMatch(in: text, options: [], range: range) != nil){
            return false
        }else{
            return true
        }
    }
    
    func phoneNumRegexCheck(text:String)->Bool{
        if(text.count != 11){
            return false
        }
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[0-9]{11}$")
        if(regex.firstMatch(in: text, options: [], range: range) != nil){
            return true
        }else{
            return false
        }
    }
    
    func emailRegexCheck(text:String) -> Bool{
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
        if(regex.firstMatch(in: text, options: [], range: range) != nil){
            return true
        }else{
            return false
        }
    }
}
