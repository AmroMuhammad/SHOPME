//
//  wishListViewModel.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/7/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class wishListViewModel : wishListViewModelType{
    var errorDrive: Driver<Bool>
    var errorSubject = PublishSubject<Bool>()
    var disposeBag = DisposeBag()
    var dataDrive: Driver<[LocalProductDetails]>
    var dataSubject = PublishSubject<[LocalProductDetails]>()
    var coreDataobj = LocalManagerHelper.localSharedInstance
    var quantutyObservable: Observable<String>
    private var quantitySubject = PublishSubject<String>()
    var checkProductInCartObservable: Observable<(Bool)>
    private var checkProductInCartSubject = PublishSubject<(Bool)>()

    init() {
           dataDrive = dataSubject.asDriver(onErrorJustReturn: [] )
           errorDrive = errorSubject.asDriver(onErrorJustReturn: false)
        quantutyObservable = quantitySubject.asObservable()
        checkProductInCartObservable = checkProductInCartSubject.asObservable()
    }
    func getwishListData() {
        let email = UserDefaults.standard.string(forKey: Constants.emailUserDefaults) ?? ""
        coreDataobj.getAllProductsFromFavorite(userEmail: email) { [weak self](result) in
            if let res = result{
                self!.dataSubject.onNext(res)
                print("the count is equal : \(res.count)")
            } else {
                print("erroooooooooooooooooooor")
                 self!.errorSubject.onNext(true)
            }
        }
    }
    func addToCart( product : LocalProductDetails) {
      //  add to cart core data and not delete from wishlist core data
        print("whishListVM - addToCart - id \(String(describing: product.productId))")
        print("whishListVM - addToCart - title \(String(describing: product.title))")
        let fav = LocalProductDetails(productId: product.productId, userEmail: product.userEmail, title: product.title, productPrice: product.productPrice, productImageData: product.productImageData, quantity: product.quantity, selectedSize: product.selectedSize, selectedColor: product.selectedColor, mainCategory: product.mainCategory, inventory_quantity: product.inventory_quantity)
        coreDataobj.addProductToCart(localProduct: fav) { (result) in
            switch result{
                    case true:
                       print("true")
                    case false:
                        print(false)
                }
            }
    }
    func deleteWishListData(product : LocalProductDetails) {
      //  delete from wishlist core data
        coreDataobj.deleteProductFromFavorite(localProductDetails: product) { [weak self](result) in
            switch result{
                case true:
                    self!.getwishListData()
                case false:
                    print(false)
            }
                        
        }
       
    }
    func getCartQuantity() {
        coreDataobj.getAllCartProducts(userEmail: getUserEmail()) { [weak self] (localProductsArr) in
            guard let self = self else {return}
            var allQuantity = 0
            if let localArr = localProductsArr {
                for item in localArr {
                    allQuantity += item.quantity ?? 0
                }
            }
            self.quantitySubject.onNext(String(allQuantity))
        }
    }
    
    func getUserEmail() -> String{
        return UserData.sharedInstance.getUserFromUserDefaults().email ?? ""
    }
    
  
    func checkIfCart(productId: Int){
        print("VM B4 checkIfCart \(String(describing: productId))")
        coreDataobj.checkProduct(entityName: .CartProducts, userEmail: getUserEmail(), productId: productId) { [weak self] (product, resBool) in
            guard let self = self else {return}
//            if resBool {
                print("VM checkIfCart Found Successfully ")
                self.checkProductInCartSubject.onNext(resBool)
//            }
            
        }
        
    }
}
