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
    var noItemsObservable: Observable<Bool>
    var quantutyObservable: Observable<String>
    
    private var shopifyAPI:CategoryAPIContract!
    private var localManager: LocalManagerHelper!
    var data:[CategoryProduct]?
    private var mainCatDatasubject = PublishSubject<[String]>()
    private var subCatDatasubject = PublishSubject<[String]>()
    private var productDatasubject = PublishSubject<[CategoryProduct]>()
    private var searchDatasubject = PublishSubject<[CategoryProduct]>()
    private var quantitySubject = PublishSubject<String>()
    
    private var errorsubject = PublishSubject<Bool>()
    private var loadingsubject = PublishSubject<Bool>()
    private var noItemSubject = PublishSubject<Bool>()


    init() {
        mainCatDataObservable = mainCatDatasubject.asObservable()
        subCatDataObservable = subCatDatasubject.asObservable()
        productDataObservable = productDatasubject.asObservable()
        searchDataObservable = searchDatasubject.asObservable()
        noItemsObservable = noItemSubject.asObservable()
        quantutyObservable = quantitySubject.asObservable()
        
        errorObservable = errorsubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        
        shopifyAPI = ShopifyAPI.shared
        localManager = LocalManagerHelper.localSharedInstance
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
                self?.errorsubject.onNext(false)
                self?.data = cat?.products
                let filteredData = self?.data?.filter({(catItem) -> Bool in
                    catItem.productType.capitalized == subCat.capitalized
                })
                if(filteredData?.isEmpty ?? true){
                    self?.noItemSubject.onNext(true)
                }else{
                    self?.noItemSubject.onNext(false)
                }
                self?.productDatasubject.onNext(filteredData ?? [])
                self?.data = filteredData
                self?.loadingsubject.onNext(false)
            case .failure(_):
                self?.loadingsubject.onNext(false)
                self?.errorsubject.onNext(true)
            }
        }
    }
    
    func getCartQuantity() {
        localManager.getAllCartProducts(userEmail: getUserEmail()) { [weak self] (localProductsArr) in
            guard let self = self else {return}
            var allQuantity = 0
            if let localArr = localProductsArr {
                for item in localArr {
                    allQuantity += item.quantity ?? 0
                }
            }
            self.quantitySubject.onNext(String(allQuantity))
        }
    }
    
    func getUserEmail() -> String{
        return UserData.sharedInstance.getUserFromUserDefaults().email ?? ""
    }
}
