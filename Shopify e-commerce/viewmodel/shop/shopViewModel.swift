//
//  shopViewModel.swift
//  Shopify e-commerce
//
//  Created by marwa on 5/25/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class shopViewModel  : shopViewModelType{
    var discountCodeDrive: Driver<[String]>
    var disposeBag = DisposeBag()
    var dataDrive: Driver<[Product]>
    var loadingDriver: Driver<Bool>
    var errorDriver: Driver<String>
    var searchValue : BehaviorRelay<String> = BehaviorRelay(value: "")
    var searchData : [Product] = []
    lazy var searchValueObservable:Observable<String> = searchValue.asObservable()
    var dataSubject = PublishSubject<[Product]>()
    var discountCodeSubject = PublishSubject<[String]>()
    var loadingSubject = PublishSubject<Bool>()
    var errorSubject = PublishSubject<String>()
    var getDataobj = ShopifyAPI.shared
    init() {
        dataDrive = dataSubject.asDriver(onErrorJustReturn: [] )
        discountCodeDrive = discountCodeSubject.asDriver(onErrorJustReturn: [])
        loadingDriver =  loadingSubject.asDriver(onErrorJustReturn: true)
        errorDriver = errorSubject.asDriver(onErrorJustReturn: "")
        
        searchValueObservable.subscribe(onNext: {[weak self] (value) in
        print("value is \(value)")
            let filteredData = self?.searchData.filter({ (product) -> Bool in
                product
                .productType.lowercased().prefix(value.count) == value.lowercased()
        })
      self?.dataSubject.onNext(filteredData ?? [])
        }).disposed(by: disposeBag)

    }
    func fetchWomenData() {
        loadingSubject.onNext(true)
        getDataobj.getAllWomanProductData(completion: { [weak self](result) in
            switch result{
            case .success(let data):
                self?.searchData = data!.products
                self?.loadingSubject.onNext(false)
                self?.dataSubject.onNext(data?.products ?? [])
            case .failure(_):
                self?.loadingSubject.onNext(false)
                self?.errorSubject.onNext(Constants.genericError)
            }
        }

   )}
    
    func fetchMenData() {
           loadingSubject.onNext(true)
                getDataobj.getAllMenProductData(completion: { [weak self](result) in
                    switch result{
                    case .success(let data):
                        self?.searchData = data!.products
                        self?.loadingSubject.onNext(false)
                        self?.dataSubject.onNext(data?.products ?? [])
                    case .failure(_):
                        self?.loadingSubject.onNext(false)
                        self?.errorSubject.onNext(Constants.genericError)
                    }
                }

           )
       }
       
   func fetchKidsData() {
           loadingSubject.onNext(true)
                getDataobj.getAllKidsProductData(completion: { [weak self](result) in
                    switch result{
                    case .success(let data):
                        self?.searchData = data!.products
                        self?.loadingSubject.onNext(false)
                        self?.dataSubject.onNext(data?.products ?? [])
                    case .failure(_):
                        self?.loadingSubject.onNext(false)
                        self?.errorSubject.onNext(Constants.genericError)
                    }
                }

           )
       }
    func fetchDiscountCodeData() {
        getDataobj.getDiscountCodeData {[weak self] (result) in
            switch result{
            
            case .success(let data):
                self!.discountCodeSubject.onNext(data?.discountCodes ?? [] )
            case .failure(_):
                self?.errorSubject.onNext(Constants.genericError)
            }
        }
    }
    
       
       
}
