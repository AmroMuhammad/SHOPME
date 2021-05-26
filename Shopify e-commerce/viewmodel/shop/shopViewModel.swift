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
class shopViewModel  : viewModelType{
    var dataDrive: Driver<[Product]>
    var loadingDriver: Driver<Bool>
    var errorDriver: Driver<String>

    var dataSubject = PublishSubject<[Product]>()
    var loadingSubject = PublishSubject<Bool>()
    var errorSubject = PublishSubject<String>()
    var getDataobj = ShopifyAPI.shared
    init() {
        dataDrive = dataSubject.asDriver(onErrorJustReturn: [])
        loadingDriver =  loadingSubject.asDriver(onErrorJustReturn: true)
        errorDriver = errorSubject.asDriver(onErrorJustReturn: "")

    }
    func fetchData() {
        loadingSubject.onNext(true)
        getDataobj.getAllWomanProductData(completion: { [weak self](result) in
            switch result{
            case .success(let data):
                self?.loadingSubject.onNext(false)
                self?.dataSubject.onNext(data?.product ?? [])
            case .failure(_):
                self?.loadingSubject.onNext(false)
                self?.errorSubject.onNext(Constants.genericError)
            }
        }

   )}
}
