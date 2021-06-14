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
    var connectivityDriver: Driver<Bool>
    var discountCodeDrive: Driver<[DiscountCodeElement]>
    var disposeBag = DisposeBag()
    var dataDrive: Driver<[Product]>
    var loadingDriver: Driver<Bool>
    var errorDriver: Driver<String>
    var searchData : [Product] = []
    var dataSubject = PublishSubject<[Product]>()
    var discountCodeSubject = PublishSubject<[DiscountCodeElement]>()
    var loadingSubject = PublishSubject<Bool>()
    var errorSubject = PublishSubject<String>()
    var connectivitySubject = PublishSubject<Bool>()
    var getDataobj = ShopifyAPI.shared
    let localManager = LocalManagerHelper.localSharedInstance
    var quantutyObservable: Observable<Int>
    private var quantitySubject = PublishSubject<Int>()
    
    init() {
        dataDrive = dataSubject.asDriver(onErrorJustReturn: [] )
        discountCodeDrive = discountCodeSubject.asDriver(onErrorJustReturn: [])
        loadingDriver =  loadingSubject.asDriver(onErrorJustReturn: false)
        errorDriver = errorSubject.asDriver(onErrorJustReturn: "")
        connectivityDriver = connectivitySubject.asDriver(onErrorJustReturn: false)
        quantutyObservable = quantitySubject.asObservable()
    }
    func fetchWomenData() {
        if(!Connectivity.isConnectedToInternet){
            connectivitySubject.onNext(true)
                return
        }
        connectivitySubject.onNext(false)
        loadingSubject.onNext(true)
        getDataobj.getAllWomanProductData(completion: { [weak self](result) in
            switch result{
            case .success(let data):
                self?.searchData = data!.products
                self?.loadingSubject.onNext(false)
                self?.dataSubject.onNext(data?.products ?? [])
            case .failure(_):
                self?.loadingSubject.onNext(false)
              //  self?.errorSubject.onNext(Constants.genericError)
                self?.connectivitySubject.onNext(true)
            }
        }

   )}
    
    func fetchMenData() {
        if(!Connectivity.isConnectedToInternet){
            connectivitySubject.onNext(true)
                return
        }
        connectivitySubject.onNext(false)
           loadingSubject.onNext(true)
                getDataobj.getAllMenProductData(completion: { [weak self](result) in
                    switch result{
                    case .success(let data):
                        self?.searchData = data!.products
                        self?.loadingSubject.onNext(false)
                        self?.dataSubject.onNext(data?.products ?? [])
                    case .failure(_):
                        self?.loadingSubject.onNext(false)
                        //self?.errorSubject.onNext(Constants.genericError)
                        self?.connectivitySubject.onNext(true)
                    }
                }

           )
       }
       
   func fetchKidsData() {
    if(!Connectivity.isConnectedToInternet){
        connectivitySubject.onNext(true)
            return
    }
    connectivitySubject.onNext(false)
           loadingSubject.onNext(true)
                getDataobj.getAllKidsProductData(completion: { [weak self](result) in
                    switch result{
                    case .success(let data):
                        self?.searchData = data!.products
                        self?.loadingSubject.onNext(false)
                        self?.dataSubject.onNext(data?.products ?? [])
                    case .failure(_):
                        self?.loadingSubject.onNext(false)
                        //self?.errorSubject.onNext(Constants.genericError)
                        self?.connectivitySubject.onNext(true)
                    }
                }

           )
       }
    func fetchDiscountCodeData() {
        if(!Connectivity.isConnectedToInternet){
            connectivitySubject.onNext(true)
                return
        }
        connectivitySubject.onNext(false)
        getDataobj.getDiscountCodeData {[weak self] (result) in
            switch result{
            
            case .success(let data):
                self!.discountCodeSubject.onNext(data?.discountCodes ?? [] )
            case .failure(_):
              //  self?.errorSubject.onNext(Constants.genericError)
                self?.connectivitySubject.onNext(true)
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
            self.quantitySubject.onNext(allQuantity)
        }
    }
    
    func getUserEmail() -> String {
        return UserDefaults.standard.string(forKey: Constants.emailUserDefaults) ?? ""
//        return "ahm@d.com"
    }
       
}
