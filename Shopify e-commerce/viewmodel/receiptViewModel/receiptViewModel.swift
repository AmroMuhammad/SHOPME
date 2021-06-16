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
    var allProductTypeDrive: Driver<[String]>
    var disposeBag = DisposeBag()
    private var itemNumSubject = PublishSubject<Int>()
    private var allProductTypeSubject = PublishSubject<[String]>()
    private var shopifyAPI:PaymentAPIContract
    private var errorSubject = PublishSubject<String>()
    private var dataSubject = PublishSubject<String>()
    private var loadingSubject = PublishSubject<Bool>()

    private var data:[LocalProductDetails]!
    private var localManager:LocalManagerHelper
    
    init() {
        itemNumDrive = itemNumSubject.asDriver(onErrorJustReturn: 0 )
        allProductTypeDrive = allProductTypeSubject.asDriver(onErrorJustReturn: [] )
        shopifyAPI = ShopifyAPI.shared
        loadingObservable = loadingSubject.asObservable()
        dataObservable = dataSubject.asObservable()
        errorObservable = errorSubject.asObservable()
        localManager = LocalManagerHelper.localSharedInstance
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
    
    func getAllProductType(products: [LocalProductDetails]) {
        data = products
        var AllProductType : [String] = []
        var count = 0
        while count < products.count {
            AllProductType.append(products[count].mainCategory!)
            count += 1
        }
        allProductTypeSubject.onNext(AllProductType)
    }
    func fetchData(paymentTextField:STPPaymentCardTextField,viewController:UIViewController,totalPrice:String){
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
                        self?.saveOrder(totalPrice: totalPrice)
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
    
    func saveOrder(totalPrice:String){
        let orderid = orderID()
        for item in data {
            let order = Order(productId: item.productId, userEmail: UserData.sharedInstance.getUserFromUserDefaults().email!, title: item.title!, productPrice: item.productPrice!, productImage: item.productImageData, quantity: "\(item.quantity!)", totalPrice: totalPrice, creationDate: getDate(), orderId: orderid)
            
            localManager.addOrder(order: order) { (value) in
                switch value{
                case true:
                    print("order added successfully")
                case false:
                    print("order not added")
                }
            }
        }
    }
    
    private func getDate()->String{
     let time = Date()
     let timeFormatter = DateFormatter()
     timeFormatter.dateFormat = "dd-MMM-yyyy HH:mm a"
     let stringDate = timeFormatter.string(from: time)
     return stringDate
    }
    
    private func orderID() -> Int {
        var result = 0
        var pow = 1
        for _ in 0..<11 {
            pow *= 10
            result += (Int.random(in: 1...9)*pow)
        }
        return result
    }


    
}
