//
//  MeViewModel.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 05/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift

class MeViewModel : MeViewModelContract{
    
    private var errorSubject = PublishSubject<(String,Bool)>()
    private var loadingSubject = PublishSubject<Bool>()
    private var signedInSubject = PublishSubject<Bool>()

    private var data:[Customer]!
    private var shopifyAPI:ShopifyAPI!
    private var userData:UserData!

    var errorObservable: Observable<(String, Bool)>
    var loadingObservable: Observable<Bool>
    var signedInObservable: Observable<Bool>

    
    init() {
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingSubject.asObservable()
        signedInObservable = signedInSubject.asObservable()

        shopifyAPI = ShopifyAPI.shared
        userData = UserData.sharedInstance
    }
    
    func validateRegisterdData(email: String, password: String) {
        if(email.isEmpty || password.isEmpty){
            errorSubject.onNext(("Please enter email and password", true))
            return
        }
        if(!emailRegexCheck(text: email)){
            errorSubject.onNext(("Please enter valid Email", true))
            return
        }
        fetchData(email: email,password: password)
    }
    
    func fetchData(email: String, password: String) {
        loadingSubject.onNext(true)
        shopifyAPI.getCustomers {[weak self] (result) in
            switch result{
            case .success(let AllCustomers):
                self?.data = AllCustomers?.customers
                self?.userExistance(email: email,password: password)
            case .failure(let error):
                self?.loadingSubject.onNext(false)
                self?.errorSubject.onNext((error.localizedDescription, true))
                self?.signedInSubject.onNext(false)
            }
        }
    }
    
    private func userExistance(email: String, password: String){
        for customer in data{
            if(customer.email == email && customer.tags == password){
                loadingSubject.onNext(false)
                signedInSubject.onNext(true)
                userData.saveUserDefaults(customer: customer)
                return
            }
        }
        loadingSubject.onNext(false)
        errorSubject.onNext(("Email or password is Wrong", true))
        signedInSubject.onNext(false)
    }
    
    private func emailRegexCheck(text:String) -> Bool{
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
        if(regex.firstMatch(in: text, options: [], range: range) != nil){
            return true
        }else{
            return false
        }
    }
    
//    func featchCustomerData(){
//        api.getCustomers { (result) in
//            switch(result){
//            case .success(let response):
//                let customers = response
//                print(customers!.customers)
//                self.customer = customers?.customers
//
//            case .failure(let error):
//                print("error")
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
    
    func signOutUser() -> Void {
        //userData.deleteUserDefaults()
    }
    
    
}
