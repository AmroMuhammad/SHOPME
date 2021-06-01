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
    var productDataObservable: Observable<[CategoryProduct]>

    var errorObservable: Observable<Bool>
    var LoadingObservable: Observable<Bool>
    
    private var shopifyAPI:CategoryAPIContract!
    private var data:[CategoryProduct]?
    private var mainCatDatasubject = PublishSubject<[String]>()
    private var subCatDatasubject = PublishSubject<[String]>()
    private var productDatasubject = PublishSubject<[CategoryProduct]>()
    

    
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
        
        shopifyAPI = ShopifyAPI.shared
    }
    
    func fetchData() {
        mainCatDatasubject.onNext(Constants.mainCategories)
        subCatDatasubject.onNext(Constants.subCategories)
    }
    
    func fetchCatProducts(mainCat:String,subCat:String){
        Loadingsubject.onNext(true)
        print(mainCat + " " + subCat)
        shopifyAPI.getCategoryProducts(catType: mainCat) {[weak self] (result) in
            switch result{
            case .success(let cat):
                self?.data = cat?.products
                let filteredData = self?.data?.filter({(catItem) -> Bool in
                    catItem.productType.capitalized == subCat.capitalized
                })
                self?.productDatasubject.onNext(filteredData ?? [])
                self?.Loadingsubject.onNext(false)
            case .failure(let error):
                self?.Loadingsubject.onNext(false)
                self?.errorsubject.onError(error)
            }
        }
    }
    
}
