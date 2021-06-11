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
    var disposeBag = DisposeBag()
    var dataDrive: Driver<[CartProduct]>
    var dataSubject = PublishSubject<[CartProduct]>()
    var totalPriceDrive: Driver<Double>
    var totalPriceSubject = PublishSubject<Double>()
    var coreDataobj = LocalManagerHelper.localSharedInstance
   // private var userDefaults = UserDefaults.standard
    
    init() {
        dataDrive = dataSubject.asDriver(onErrorJustReturn: [] )
        totalPriceDrive = totalPriceSubject.asDriver(onErrorJustReturn: 0.0 )
    }
    func getCartData() {
        //get data from core data
    //  let email = UserDefaults.standard.string(forKey: "email")
        coreDataobj.getAllCartProducts(userEmail: "ahm@d.com") { [weak self](result) in
            switch result{
            case .success(let data):
                self!.dataSubject.onNext(data ?? [])
                self!.totalPrice(products: data ?? [])
                print("the count is equal : \(data?.count ?? 0)")
            case .failure(_):
                print("erroooooooooooooooooooor")
            }
        }
        
    }
    func totalPrice(products: [CartProduct]) {
        var totalPrice : Double = 0.0
        var count = 0
        while count < products.count {
            totalPrice += Double(products[count].productPrice)!
            count += 1
        }
        totalPriceSubject.onNext(totalPrice)
    }
    
    func moveToWishList(product:CartProduct) {
      //  delete from cart core data and add to wishlist core data
        coreDataobj.deleteProductFromCart(cartObj: product) {[weak self] (result) in
            switch result{
            case true:
                self!.getCartData()
            case false:
                print("error")
            }
        }
        coreDataobj.addProductToFavorite(favoriteProduct: product as FavoriteProduct) { (result) in
            switch result{
                
            case true:
                print(true)
            case false:
                print(false)
            }
        }
       
    }
    func deleteCartData(product: CartProduct) {
      //  delete from cart core data
        coreDataobj.deleteProductFromCart(cartObj: product) { [weak self](result) in
            switch result{
                case true:
                    self!.getCartData()
                case false:
                    print(false)
            }
        }
    }
    func changeProductNumber(product: CartProduct){
        print("\(product.quantity ?? 0)")
        coreDataobj.updateCartProduct(cartObj: product) {[weak self] (result) in
             switch result{
                case true:
                    self!.getCartData()
                case false:
                    print(false)
                       }
        }
    }
    
}
