//
//  SearchViewModel.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/2/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel : SearchViewModelContract{
    var dataObservable: Observable<[Product]>
    var searchValue : BehaviorRelay<String> = BehaviorRelay(value: "")
    var errorObservable: Observable<Bool>
    var LoadingObservable: Observable<Bool>
    
    private lazy var searchValueObservable:Observable<String> = searchValue.asObservable()
    private var disposeBag = DisposeBag()
    private var datasubject = PublishSubject<[Product]>()
    private var shopifyAPI:AllProductsAPIContract!
    private var errorsubject = PublishSubject<Bool>()
    private var Loadingsubject = PublishSubject<Bool>()
    private var data:[Product]!

 
    init() {
        shopifyAPI = ShopifyAPI.shared
        dataObservable = datasubject.asObservable()
        errorObservable = errorsubject.asObservable()
        LoadingObservable = Loadingsubject.asObservable()
        
        searchValueObservable.subscribe(onNext: {[weak self] (value) in
        print("value is \(value)")
        let filteredData = self?.data?.filter({ (product) -> Bool in
//          product.title.lowercased().prefix(value.count) == value.lowercased()
            product.title.lowercased().contains(value.lowercased())
        })
            
        self?.datasubject.onNext(filteredData ?? [])
        }).disposed(by: disposeBag)
    }
    
    func fetchData(){
        Loadingsubject.onNext(true)
        shopifyAPI.getAllProducts {[weak self] (result) in
            switch result{
            case .success(let products):
                self?.data = products?.products
                self?.datasubject.onNext(products?.products ?? [])
                self?.Loadingsubject.onNext(false)
            case .failure(let error):
                self?.Loadingsubject.onNext(false)
                self?.errorsubject.onError(error)
            }
        }
    }
    
}
