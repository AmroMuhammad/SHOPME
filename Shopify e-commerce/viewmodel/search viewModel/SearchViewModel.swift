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
    private var filteredData:[Product]!

 
    init() {
        shopifyAPI = ShopifyAPI.shared
        dataObservable = datasubject.asObservable()
        errorObservable = errorsubject.asObservable()
        LoadingObservable = Loadingsubject.asObservable()
        filteredData = data
        
        searchValueObservable.subscribe(onNext: {[weak self] (value) in
        print("value is \(value)")
            self?.filteredData = self?.data?.filter({ (product) -> Bool in
//          product.title.lowercased().prefix(value.count) == value.lowercased()
            product.title.lowercased().contains(value.lowercased())
        })
        if(self?.filteredData != nil){
            if(self!.filteredData!.isEmpty){
                self?.filteredData = self?.data
            }
        }
        self?.datasubject.onNext(self?.filteredData ?? [])
        }).disposed(by: disposeBag)
    }
    
    func fetchData(){
        Loadingsubject.onNext(true)
        shopifyAPI.getAllProducts {[weak self] (result) in
            switch result{
            case .success(let products):
                self?.data = products?.products
                self?.filteredData = self?.data
                self?.datasubject.onNext(products?.products ?? [])
                self?.Loadingsubject.onNext(false)
            case .failure(let error):
                self?.Loadingsubject.onNext(false)
                self?.errorsubject.onError(error)
            }
        }
    }
    
    func sortData(index:Int){
        switch index {
        case 0:
            filteredData = data.sorted { (product1, product2) -> Bool in
                Double(product1.variants[0].price)! > Double(product2.variants[0].price)!
            }
        default:
            filteredData = data.sorted { (product1, product2) -> Bool in
                Double(product1.variants[0].price)! < Double(product2.variants[0].price)!
            }
        }
        datasubject.onNext(filteredData ?? data)
    }
    
    func filterData(word:String){
        filteredData = data.filter({ (product) -> Bool in
            product.productType.rawValue.lowercased() == word.lowercased()
            })
        datasubject.onNext(filteredData)
    }
}
