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
    var disposeBag = DisposeBag()
    var dataDrive: Driver<[FavoriteProduct]>
    var dataSubject = PublishSubject<[FavoriteProduct]>()
    var coreDataobj = LocalManagerHelper.localSharedInstance
    init() {
           dataDrive = dataSubject.asDriver(onErrorJustReturn: [] )
    }
    func getwishListData() {
        coreDataobj.getAllProductsFromFavorite(userEmail: "ahm@d.com") { [weak self](result) in
            switch result{
            case .success(let data):
                self!.dataSubject.onNext(data ?? [])
                print("the count is equal : \(data?.count ?? 0)")
            case .failure(_):
                print("erroooooooooooooooooooor")
            }
        }
    }
    func addToCart( product : FavoriteProduct) {
      //  add to cart core data and not delete from wishlist core data
        let fav = CartProduct(productId: product.productId, productPrice: product.productPrice, productImageData: product.productImageData, userEmail: product.userEmail, title: "no name", selectedSize: "x", selectedColor: "red", quantity: 1)
        coreDataobj.addProductToCart(cartObj: fav) { (result) in
            switch result{
                    case true:
                       print("true")
                    case false:
                        print(false)
                }
            }
    }
    func deleteWishListData(product : FavoriteProduct) {
      //  delete from wishlist core data
        coreDataobj.deleteProductFromFavorite(favoriteProduct: product) { [weak self](result) in
            switch result{
                case true:
                    self!.getwishListData()
                case false:
                    print(false)
            }
                        
        }
       
    }
    
}
