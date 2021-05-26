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
//class shopViewModel  : viewModelType{
//    var dataDrive: Driver<[Sport]>
//    var loadingDriver: Driver<Bool>
//    var errorDriver: Driver<Bool>
//
//    var dataSubject = PublishSubject<[Sport]>()
//    var loadingSubject = PublishSubject<Bool>()
//    var errorSubject = PublishSubject<Bool>()
//    var obj = sportsAPI.shared
//    init() {
//        dataDrive = dataSubject.asDriver(onErrorJustReturn: [])
//        loadingDriver =  loadingSubject.asDriver(onErrorJustReturn: true)
//        errorDriver = errorSubject.asDriver(onErrorJustReturn: true)
//
//    }
//    func fetchData() {
//        loadingSubject.onNext(true)
//        obj.getAllSportsData { [weak self](result) in
//            switch result{
//
//            case .success(let data):
//                self?.loadingSubject.onNext(false)
//                self?.dataSubject.onNext(data?.sports ?? [])
//            case .failure(_):
//                self?.loadingSubject.onNext(false)
//                self?.errorSubject.onNext(true)
//            }
//        }
//    }
//
//
//}
