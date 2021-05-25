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

    var errorObservable: Observable<Bool>
    var LoadingObservable: Observable<Bool>
    
//    private var shopifyAPI:ShopifyAPI!
    private var data:[String]?
    private var mainCatDatasubject = PublishSubject<[String]>()
    private var subCatDatasubject = PublishSubject<[String]>()

    private var errorsubject = PublishSubject<Bool>()
    private var Loadingsubject = PublishSubject<Bool>()
    let mainCategories = ["Men","Women","Kids"]
    let subCategories = ["Tshirt","Shoes","Accessories"]

    
    init() {
        mainCatDataObservable = mainCatDatasubject.asObservable()
        subCatDataObservable = subCatDatasubject.asObservable()
        errorObservable = errorsubject.asObservable()
        LoadingObservable = Loadingsubject.asObservable()
    }
    
    func fetchData() {
        mainCatDatasubject.onNext(mainCategories)
        subCatDatasubject.onNext(subCategories)
    }
    
   
    
    
}
