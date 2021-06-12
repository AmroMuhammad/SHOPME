//
//  productProtocol.swift
//  Shopify e-commerce
//
//  Created by marwa on 5/26/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
protocol allProductProtocol {
    func getAllWomanProductData(completion : @escaping (Result<AllProduct?, NSError > ) -> Void)
    func getAllMenProductData(completion : @escaping (Result<AllProduct?, NSError > ) -> Void)
    func getAllKidsProductData(completion : @escaping (Result<AllProduct?, NSError > ) -> Void)
    func getDiscountCodeData(completion : @escaping (Result<discountCode?, NSError > ) -> Void)
}
protocol viewModelType {
   
    var loadingDriver : Driver<Bool>{get}
    var errorDriver : Driver<String>{get}
    
}

protocol shopViewModelType : viewModelType {
    var connectivityDriver: Driver<Bool> {get}
    var dataDrive : Driver<[Product]> {get}
    var  discountCodeDrive : Driver<[DiscountCodeElement]> {get}
    var quantutyObservable: Observable<Int> {get}
    func getCartQuantity() 
    func fetchWomenData()
    func fetchMenData()
    func fetchKidsData()
    func fetchDiscountCodeData()
}
protocol CollectionViewCellDelegate{
    func showAlert(msg : String ,  product : LocalProductDetails)
    func showMovingAlert(msg: String ,  product : LocalProductDetails)
}

protocol TableViewCellDelegate {
    func showAlert(msg: String, product:LocalProductDetails , completion: @escaping (Int) -> Void)
    func showMovingAlert(msg: String , product:LocalProductDetails)
    func updateCoreDate(product:LocalProductDetails)
    
}

protocol wishListViewModelType {
     var dataDrive : Driver<[LocalProductDetails]> {get}
     func getwishListData()
     func addToCart( product : LocalProductDetails)
     func deleteWishListData( product : LocalProductDetails)
}
protocol cartViewModelType {
     var totalPriceDrive: Driver<Double>{get}
     var dataDrive : Driver<[LocalProductDetails]> {get}
     func getCartData()
     func moveToWishList(product:LocalProductDetails)
     func deleteCartData(product: LocalProductDetails)
     func changeProductNumber(product: LocalProductDetails)
     
}
