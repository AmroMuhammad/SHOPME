//
//  cartViewModel.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/7/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class cartViewModel : cartViewModelType {
    var errorDrive: Driver<Bool>
    var disposeBag = DisposeBag()
    var dataDrive: Driver<[LocalProductDetails]>
    var dataSubject = PublishSubject<[LocalProductDetails]>()
    var errorSubject = PublishSubject<Bool>()
    var totalPriceDrive: Driver<Double>
    var totalPriceSubject = PublishSubject<Double>()
    var coreDataobj = LocalManagerHelper.localSharedInstance
   // private var userDefaults = UserDefaults.standard
    
    var inventoryQuantity = 0
    
    init() {
        dataDrive = dataSubject.asDriver(onErrorJustReturn: [] )
        errorDrive = errorSubject.asDriver(onErrorJustReturn: false)
        totalPriceDrive = totalPriceSubject.asDriver(onErrorJustReturn: 0.0 )
    }
    func getCartData() {
        //get data from core data
        let email = UserDefaults.standard.string(forKey: Constants.emailUserDefaults) ?? ""
        coreDataobj.getAllCartProducts(userEmail: email) { [weak self](result) in
            if  let res = result {
                self!.dataSubject.onNext(res)
                self!.totalPrice(products: res)
                print("the count is equal : \(res.count)")
            } else {
                print("erroooooooooooooooooooor")
                self!.errorSubject.onNext(true)
                
            }
        }
        
    }
    func totalPrice(products: [LocalProductDetails]) {
        var totalPrice: Double = 0.0
        var count = 0
        while count < products.count {
            totalPrice += ((Double(products[count].productPrice ?? "0.0") ?? 0.0) * Double(products[count].quantity ?? 1) )
//            totalPrice += (Double(products[count].productPrice)! * Double(products[count].quantity ?? 1))
            count += 1
        }
        totalPrice = (totalPrice * 100).rounded() / 100
        totalPriceSubject.onNext(totalPrice)
    }
    
    func moveToWishList(product:LocalProductDetails) {
      //  delete from cart core data and add to wishlist core data
        coreDataobj.deleteProductFromCart(localProductDetails: product) {[weak self] (result) in
            switch result{
            case true:
                self!.getCartData()
            case false:
                print("error")
            }
        }
        coreDataobj.addProductToFavorite(localProduct: product) { (result) in
            switch result{
                
            case true:
                print(true)
            case false:
                print(false)
            }
        }
       
    }
    func deleteCartData(product: LocalProductDetails) {
      //  delete from cart core data
        coreDataobj.deleteProductFromCart(localProductDetails: product) { [weak self](result) in
            switch result{
                case true:
                    self!.getCartData()
                case false:
                    print(false)
            }
        }
    }
    func changeProductNumber(product: LocalProductDetails){
        print("\(product.quantity ?? 0)")
        coreDataobj.updateCartProduct(type: .Quantity, localProductDetails: product) {[weak self] (result) in
             switch result{
                case true:
                    self!.getCartData()
                case false:
                    print(false)
                       }
        }
    }
//    func getQuantityOfProductSize(productObject: LocalProductDetails) -> Int? {
//        
//        var selectedSize: String?
//        let variantsArr = productObject?.variants ?? []
//        for item in variantsArr {
//            if item.option1 == selectedSize {
//                return item.inventory_quantity
//            }
//        }
//        return 0
//    }
    
}
