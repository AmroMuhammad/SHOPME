//
//  categoryViewModelContract.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/25/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import TKFormTextField

protocol CategoryViewModelContract:ViewModelType{
    var mainCatDataObservable:Observable<[String]> {get}
    var subCatDataObservable:Observable<[String]> {get}
    var productDataObservable: Observable<[CategoryProduct]> {get}
    var data:[CategoryProduct]? {get}
    func fetchCatProducts(mainCat:String,subCat:String)
    var noItemsObservable: Observable<Bool> {get}
    var quantutyObservable: Observable<String> {get}
    func getCartQuantity()

}

protocol SearchViewModelContract:ViewModelType{
    var dataObservable: Observable<[SearchProduct]>{get}
    
}

protocol RegisterViewModelContract{
    var errorObservable:Observable<(String,Bool)>{get}
    var loadingObservable: Observable<Bool> {get}
    var doneObservable: Observable<Bool>{get}
    func postData(newCustomer:RegisterCustomer)
        func validateRegisterdData(firstName:String,lastName:String,email:String,phoneNumber:String,password:String,confirmPassword:String,country:String,city:String,address:String)
}

protocol MeViewModelContract{
    var errorObservable:Observable<(String,Bool)>{get}
    var loadingObservable: Observable<Bool> {get}
    var localObservable: Observable<[LocalProductDetails]> {get}
    var signedInObservable: Observable<Bool> {get}
    var ordersObservable:Observable<[Order]> {get}
    func validateRegisterdData(email:String,password:String)
    func fetchData(email: String, password: String)
    func fetchLocalData()
}


protocol EditViewModelContract{
    var dataObservable: Observable<Customer>{get}
    var errorObservable:Observable<(String,Bool)>{get}
    var loadingObservable: Observable<Bool> {get}
    func fetchData()
    func postData(newCustomer:RegisterCustomer)
    func validateData(firstName:String,lastName:String,email:String,phoneNumber:String,country:String,city:String,address:String)
}

