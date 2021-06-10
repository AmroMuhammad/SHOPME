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
    var searchDataObservable: Observable<[CategoryProduct]>
    var errorObservable: Observable<Bool>
    var loadingObservable: Observable<Bool>
    
    private var shopifyAPI:CategoryAPIContract!
    var data:[CategoryProduct]?
    private var mainCatDatasubject = PublishSubject<[String]>()
    private var subCatDatasubject = PublishSubject<[String]>()
    private var productDatasubject = PublishSubject<[CategoryProduct]>()
    private var searchDatasubject = PublishSubject<[CategoryProduct]>()


    
    private var errorsubject = PublishSubject<Bool>()
    private var loadingsubject = PublishSubject<Bool>()

    init() {
        mainCatDataObservable = mainCatDatasubject.asObservable()
        subCatDataObservable = subCatDatasubject.asObservable()
        productDataObservable = productDatasubject.asObservable()
        searchDataObservable = searchDatasubject.asObservable()

        errorObservable = errorsubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        
        shopifyAPI = ShopifyAPI.shared
    }
    
    func fetchData() {
        mainCatDatasubject.onNext(Constants.mainCategories)
        subCatDatasubject.onNext(Constants.subCategories)
    }
    
    func fetchCatProducts(mainCat:String,subCat:String){
        loadingsubject.onNext(true)
        print(mainCat + " " + subCat)
        shopifyAPI.getCategoryProducts(catType: mainCat) {[weak self] (result) in
            switch result{
            case .success(let cat):
                self?.data = cat?.products
                let filteredData = self?.data?.filter({(catItem) -> Bool in
                    catItem.productType.capitalized == subCat.capitalized
                })
                self?.productDatasubject.onNext(filteredData ?? [])
                self?.data = filteredData
                self?.loadingsubject.onNext(false)
            case .failure(let error):
                self?.loadingsubject.onNext(false)
                self?.errorsubject.onError(error)
            }
        }
    }
    
}
