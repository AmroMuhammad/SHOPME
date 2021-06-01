//
//  CategoryViewModel.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/25/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift

class CategoryViewModel : CategoryViewModelContract{
    var mainCatDataObservable: Observable<[String]>
    var subCatDataObservable: Observable<[String]>
    var productDataObservable: Observable<[String]>

    var errorObservable: Observable<Bool>
    var LoadingObservable: Observable<Bool>
    
//    private var shopifyAPI:ShopifyAPI!
    private var data:[String]?
    private var mainCatDatasubject = PublishSubject<[String]>()
    private var subCatDatasubject = PublishSubject<[String]>()
    private var productDatasubject = PublishSubject<[String]>()

    
    private var errorsubject = PublishSubject<Bool>()
    private var Loadingsubject = PublishSubject<Bool>()
    let menTshirt = ["1","2","3"]
    let menShoes = ["4","5","6"]
    let menAcc = ["7","8","9"]
    let womenTshirt = ["10","11","12"]
    let womenShoes = ["13","14","15"]
    let womenAcc = ["16","17","18"]
    let kidTshirt = ["19","20","21"]
    let kidShoes = ["22","23","24"]
    let kidAcc = ["25","26","27"]


    
    init() {
        mainCatDataObservable = mainCatDatasubject.asObservable()
        subCatDataObservable = subCatDatasubject.asObservable()
        productDataObservable = productDatasubject.asObservable()

        errorObservable = errorsubject.asObservable()
        LoadingObservable = Loadingsubject.asObservable()
    }
    
    func fetchData() {
        mainCatDatasubject.onNext(Constants.mainCategories)
        subCatDatasubject.onNext(Constants.subCategories)
    }
    
    func fetchCetainData(mainCat:String,subCat:String){
        print(mainCat + " " + subCat)
        if(mainCat == Constants.mainCategories[0]){
            if(subCat == Constants.subCategories[0]){
                productDatasubject.onNext(menTshirt)
            }else if(subCat == Constants.subCategories[1]){
                productDatasubject.onNext(menShoes)
            }else{
                productDatasubject.onNext(menAcc)
            }
        }else if(mainCat == Constants.mainCategories[1]){
            if(subCat == Constants.subCategories[0]){
                productDatasubject.onNext(womenTshirt)
            }else if(subCat == Constants.subCategories[1]){
                productDatasubject.onNext(womenShoes)
            }else{
                productDatasubject.onNext(womenAcc)
            }
        }else{
            if(subCat == Constants.subCategories[0]){
                productDatasubject.onNext(kidTshirt)
            }else if(subCat == Constants.subCategories[1]){
                productDatasubject.onNext(kidShoes)
            }else{
                productDatasubject.onNext(kidAcc)
            }
        }
    }
    
}
