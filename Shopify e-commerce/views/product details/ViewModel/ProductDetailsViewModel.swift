//
//  ProductDetailsViewModel.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 03/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift

class ProductDetailsViewModel {
    
    var imagesObservable: Observable<[ProductImage]>
    var colorsObservable: Observable<[UIColor]>
    var sizesObservable: Observable<[String]>
    var productTitleObservable: Observable<String>
    var productPriceObservable: Observable<String>
    
    private var imagesSubject = PublishSubject<[ProductImage]>()
    private var colorsSubject = PublishSubject<[UIColor]>()
    private var sizesSubject = PublishSubject<[String]>()
    private var productTitleSubject = PublishSubject<String>()
    private var productPriceSubject = PublishSubject<String>()
    
    private var shopifyAPI: ShopifyAPI!
    
    
    init() {
        imagesObservable = imagesSubject.asObservable()
        colorsObservable = colorsSubject.asObservable()
        sizesObservable = sizesSubject.asObservable()
        productTitleObservable = productTitleSubject.asObservable()
        productPriceObservable = productPriceSubject.asObservable()
        
        shopifyAPI = ShopifyAPI.shared
    }
    
    func getProductDetails(id: String){
        shopifyAPI.getProductDetails(productId: id) { (result) in
            switch(result){
            case .success(let product):
                print("VM => id => \(product?.product.id ?? 707)")
                if let productResponse = product {
//                    self.productDetailsDataSubject.onNext(productResponse.product)
                    self.filterData(product: productResponse.product)
                }
            case .failure(let err):
                print("\n\n\n\n errrrr => \(err.localizedDescription) \nEND\n\n\n\n")
            }
        }
    }
    
    func filterData(product: Product) {
        if let imgsArr = product.images {
            imagesSubject.onNext(imgsArr)
        }
        if let productName = product.title {
            productTitleSubject.onNext(productName)
        }
        if let productPrice = product.variants?[0].price {
            productPriceSubject.onNext(productPrice)
        }
        if let optionsArr = product.options {
            for option in optionsArr {
                if option.name == "Color" {
                    if let clrsArr = option.values{
                        print("COLOR DIDSET")
                        colorsSubject.onNext(mapToColors(colorsNames: clrsArr))
                        print("COLOR \(clrsArr)")
                    }
                    break
                }
            }
        }
        if let sizeArr = product.options {
            for option in sizeArr {
                if option.name == "Size" {
                    if let sizesArr = option.values{
                        print("SIZE DIDSET")
                        sizesSubject.onNext(sizesArr)
                        print("SIZE \(sizesArr)")
                    }
                    break
                }
            }
        }
//        productDetailsDataSubject.onNext(product)
    }
    
    func mapToColors(colorsNames: [String]) -> [UIColor] {
        var arrClr: [UIColor] = []
        print("COLOR MAPPINGGGGGGG")
        for clr in colorsNames {
            switch clr {
            case "black":
                arrClr.append(UIColor.black)
            case "blue":
                arrClr.append(UIColor.blue)
            case "white":
                arrClr.append(UIColor.white)
            case "yellow":
                arrClr.append(UIColor.yellow)
            case "red":
                arrClr.append(UIColor.red)
            case "beige":
                arrClr.append(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.862745098, alpha: 1))
            case "light_brown":
                arrClr.append(#colorLiteral(red: 0.7098039216, green: 0.3960784314, blue: 0.1137254902, alpha: 1))
            case "burgandy":
                arrClr.append(#colorLiteral(red: 0.5019607843, green: 0, blue: 0.1254901961, alpha: 1))
            default:
                arrClr.append(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            }
        }
        return arrClr
    }
    
    func getDeliverCity(){
        //get deliver city name from local
    }
    func getCurrency(){
        //get currency from local
    }
    
}
