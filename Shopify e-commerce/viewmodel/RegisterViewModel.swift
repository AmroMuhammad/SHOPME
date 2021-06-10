//
//  RegisterViewModel.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/10/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift

class RegisterViewModel:RegisterViewModelContract{    
    private var errorSubject = PublishSubject<(String,Bool)>()
    private var loadingsubject = PublishSubject<Bool>()
    private var doneSubject = PublishSubject<Bool>()
    private var data:Customer!
    private var shopifyAPI:RegisterAPIContract!
    
    var errorObservable: Observable<(String, Bool)>
    var loadingObservable: Observable<Bool>
    var doneObservable: Observable<Bool>

    init() {
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        doneObservable = doneSubject.asObservable()
        
        shopifyAPI = ShopifyAPI.shared
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
                //add to userDefaults
                self?.doneSubject.onCompleted()
            case .failure(let error):
                self?.loadingsubject.onNext(false)
                self?.errorSubject.onNext((error.localizedDescription, true))
            }
        }
        
    }
    
    func validateRegisterdData(firstName:String,lastName:String,email:String,phoneNumber:String,password:String,confirmPassword:String,country:String,city:String){
        
        if(firstName.isEmpty || lastName.isEmpty || email.isEmpty || phoneNumber.isEmpty || confirmPassword.isEmpty || country.isEmpty || city.isEmpty){
            errorSubject.onNext(("Please enter all fields", true))
            return
        }
        if(!nameRegexCheck(text: firstName) || !nameRegexCheck(text: lastName)){
            errorSubject.onNext(("Please enter valid First Name and Last Name", true))
            return
        }
        if(!emailRegexCheck(text: email)){
            errorSubject.onNext(("Please enter valid Email", true))
            return
        }
        if(!phoneNumRegexCheck(text: phoneNumber)){
            errorSubject.onNext(("Please enter valid phone number", true))
            return
        }
        if(password != confirmPassword){
            errorSubject.onNext(("Confirm password is worng", true))
            return
        }
        if(!nameRegexCheck(text: country) || !nameRegexCheck(text: city)){
            errorSubject.onNext(("Please enter valid country and city", true))
            return
        }
        let newCustomer = RegisterCustomer(customer: Customer(id: nil, email: email, firstName: firstName, lastName: lastName, phone: "+2"+phoneNumber, tags: password,addresses: [Address(id: nil, customerID: nil, city: city, country: country)]))
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
