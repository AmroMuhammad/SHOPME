//
//  EditInfoViewController.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/11/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import TKFormTextField

class EditInfoViewModel: EditViewModelContract{    
    private var dataSubject = PublishSubject<Customer>()
    private var errorSubject = PublishSubject<(String,Bool)>()
    private var loadingSubject = PublishSubject<Bool>()
    private var data:Customer!
    private var shopifyAPI:EditInfoAPIContract!
    private var id:Int!
    private var userData:UserData!
    public  var animationObservable:Observable<(String,Bool)>?
    public var animationSubject = PublishSubject<(String,Bool)>()
    

    var dataObservable: Observable<Customer>
    var errorObservable: Observable<(String, Bool)>
    var loadingObservable: Observable<Bool>
    
    init(){
        dataObservable = dataSubject.asObservable()
        loadingObservable = loadingSubject.asObservable()
        errorObservable = errorSubject.asObservable()
        shopifyAPI = ShopifyAPI.shared
        userData = UserData.sharedInstance
        id = userData.getUserFromUserDefaults().id
        animationObservable = animationSubject.asObservable()
        
    }
    func fetchData() {
        loadingSubject.onNext(true)
        shopifyAPI.getCustomer(id: id) {[weak self] (result) in
            switch result{
            case .success(let customer):
                self?.dataSubject.onNext(customer!.customer)
                self?.data = customer?.customer
                self?.loadingSubject.onNext(false)
            case .failure(let error):
                self?.loadingSubject.onNext(false)
                self?.errorSubject.onNext((error.localizedDescription, true))

            }
        }
    }
    
    func postData(newCustomer: RegisterCustomer) {
        loadingSubject.onNext(true)
        shopifyAPI.editCustomer(customerData: newCustomer, id: data.id!) {[weak self] (result) in
            switch result{
            case .success(let customer):
                self?.loadingSubject.onNext(false)
                self?.data = customer?.customer
                print("=============================")
                print(customer)
                self?.userData.saveUserDefaults(customer: customer!.customer)
                self?.dataSubject.onCompleted()
            case .failure(let error):
                self?.loadingSubject.onNext(false)
                self?.errorSubject.onNext((error.localizedDescription, true))
            }
        }
    }
    
    func validateData(firstName:String,lastName:String,email:String,phoneNumber:String,country:String,city:String,address:String) {
        let array = [firstName,lastName,email,phoneNumber,country,address]
        if(firstName.isEmpty || lastName.isEmpty || email.isEmpty || phoneNumber.isEmpty || country.isEmpty || city.isEmpty || address.isEmpty){

            //animationSubject.onNext(("all fields required",true))

                return
            }
            if(!nameRegexCheck(text: firstName) || !nameRegexCheck(text: lastName)){
                //animationSubject.onNext(("inavlid name",true))
                return
            }
            if(!emailRegexCheck(text: email)){

              //  animationSubject.onNext(("inavlid email",true))
                return
            }
            if(!phoneNumRegexCheck(text: phoneNumber)){
               // animationSubject.onNext(("inavlid phone number",true))
                return
            }
            if(!nameRegexCheck(text: country) || !nameRegexCheck(text: city)){

               // animationSubject.onNext(("inavlid data",true))
                return
            }
        let newCustomer = RegisterCustomer(customer: Customer(id: nil, email: email, firstName: firstName, lastName: lastName, phone: "+2"+phoneNumber, tags: data.tags,addresses: [Address(id: nil, customerID: nil, city: city, country: country, address1: address)]))
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
//
//    @objc func countryError(textField: TKFormTextField) {
//            //var phone = textField.text
//            if(textField.text == ""){
//                textField.error = "all faild are required"
//            }
//            else{
//                textField.error = nil
//            }
//
//        }
//
//        @objc func cityError(textField: TKFormTextField) {
//            //var phone = textField.text
//            if(textField.text == ""){
//                textField.error = "all faild are required"
//            }
//            else{
//                textField.error = nil
//            }
//
//        }
//
//
//        @objc func updateError(textField: TKFormTextField) {
//            //var phone = textField.text
//            if(textField.text == ""){
//                textField.error = "all faild are required"
//            }
//            else{
//                textField.error = nil
//            }
//
//        }
//        @objc func nameerror(textField: TKFormTextField) {
//            //var phone = textField.text
//            if(!nameRegexCheck(text: textField.text!)){
//                textField.error = "please enter valid name"
//            }
//            else{
//                textField.error = nil
//            }
//        }
//        @objc func passerror(textField: TKFormTextField) {
//
//    //        if(str1 != str2){
//    //            textField.error = "password not equal confirmation password"
//    //        }
//    //        else{
//    //            textField.error = nil
//    //        }
//        }
//        @objc func phoneerror(textField: TKFormTextField) {
//
//            if(!phoneNumRegexCheck(text: textField.text!)){
//                textField.error = "please enter valid phone number"
//            }
//            else{
//                textField.error = nil
//            }
//        }
            
//            @objc func emailerror(textField: TKFormTextField) {
//                //var phone = textField.text
//                if(!emailRegexCheck(text: textField.text!)){
//                    textField.error = "please enter valid email"
//                }
//                else{
//                    textField.error = nil
//                }
    //        guard let text = textField.text, !text.isEmpty else {
    //          textField.error = "Text is empty!" // to show error message in errorLabel
    //          return
    //        }
    //        textField.error = nil // to remove the error message
          }
    

