//
//  receiptViewModel.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/11/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Stripe

class receiptViewModel : receiptViewModelType {
    var errorObservable:Observable<String>
    var loadingObservable:Observable<Bool>
    var dataObservable:Observable<String>

    
    var itemNumDrive: Driver<Int>
    var disposeBag = DisposeBag()
    var itemNumSubject = PublishSubject<Int>()
    private var shopifyAPI:PaymentAPIContract
    private var errorSubject = PublishSubject<String>()
    private var dataSubject = PublishSubject<String>()
    private var loadingSubject = PublishSubject<Bool>()

    
    init() {
       itemNumDrive = itemNumSubject.asDriver(onErrorJustReturn: 0 )
        shopifyAPI = ShopifyAPI.shared
        loadingObservable = loadingSubject.asObservable()
        dataObservable = dataSubject.asObservable()
        errorObservable = errorSubject.asObservable()
    }
    
    func getItemNum(products: [LocalProductDetails]) {
        var totalItemNum : Int = 0
        var count = 0
        while count < products.count {
            totalItemNum  += products[count].quantity!
            count += 1
        }
        itemNumSubject.onNext(totalItemNum)
    }
    
    func fetchData(paymentTextField:STPPaymentCardTextField,viewController:UIViewController) {
        loadingSubject.onNext(true)
        shopifyAPI.createPaymentIntent {[weak self] (paymentIntentResponse, error) in
            if let error = error {
                self?.errorSubject.onNext(error.localizedDescription)
                self?.loadingSubject.onNext(false)
                return
            }else{
                guard let responseDictionary = paymentIntentResponse as? [String:AnyObject] else{
                    print("incorrect response")
                    self?.errorSubject.onNext("incorrect response, please try again later!")
                    self?.loadingSubject.onNext(false)
                    return}
                let clientSecret = responseDictionary["secret"] as! String
                
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                let paymentMethodParams = STPPaymentMethodParams(card: paymentTextField.cardParams, billingDetails: nil, metadata: nil)
                
                paymentIntentParams.paymentMethodParams = paymentMethodParams
                
                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: viewController as! STPAuthenticationContext) { (status, paymentInent, error) in
                    self?.loadingSubject.onNext(false)
                    switch(status){
                    case .succeeded:
                        self?.dataSubject.onNext("succeeded")
                    case .canceled:
                        self?.errorSubject.onNext("Process cancelled")
                    case .failed:
                        self?.errorSubject.onNext("Process failed, kindly use valid card")
                    @unknown default:
                        self?.errorSubject.onNext("Unknown Error, try again later!")
                    }
                }
            }
        }
    }

    
}
