//
//  ProductModel.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 03/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation

struct ProductDetailsModel: Codable {
    
    let product: ProductDetails
}

struct ProductDetails: Codable {
    
    let id: Int
    let title: String?
//    let vendor: String?          // ???
//    let product_type: String?    // ???
//    let handle: String?
//    let status: String?
//    let tags: String?
    let variants: [ProductDetailsVariants]?
    let options: [ProductDetailsOptions]?
    let images: [ProductDetailsImage]?
    let image: ProductDetailsImage?
    
}

struct ProductDetailsVariants: Codable {
    
    let id: Int
//    let product_id: Int?     // ???
    let price: String?
}

struct ProductDetailsOptions: Codable {
    
    let id: Int
    let product_id: Int?     // ???
    let name: String?
    let values: [String]?
}


struct ProductDetailsImage: Codable {
    
    let id: Int
//    let product_id: Int?     // ???
    let src: String?
}


class FavoriteProduct {
    
    let productId: Int
    let productPrice: String
    let productImageData: Data
    let userEmail: String
    
    init(productId: Int, productPrice: String, productImageData: Data, userEmail: String) {
        self.productId = productId
        self.productPrice = productPrice
        self.productImageData = productImageData
        self.userEmail = userEmail
    }
}

class CartProduct: FavoriteProduct {
    var title: String?
    var selectedSize: String?
    var selectedColor: String?
    var quantity: Int?
    
    init(productId: Int, productPrice: String, productImageData: Data, userEmail: String, title: String, selectedSize: String?, selectedColor: String?, quantity: Int?) {
        super.init(productId: productId, productPrice: productPrice, productImageData: productImageData, userEmail: userEmail)
        self.title = title
        self.selectedSize = selectedSize
        self.selectedColor = selectedColor
        self.quantity = quantity
    }
}

enum EntityName: String {
    case FavoriteProducts
    case CartProducts
}
/*

 class CartProduct: FavoriteProduct {
     var selectedSize: String?
     var selectedColor: String?
     var quantity: Int?
     
     init(selectedSize: String?, selectedColor: String?, quantity: Int?) {
         super.init(productId: <#T##Int#>, productPrice: <#T##String#>, productImageData: <#T##Data#>)
         self.selectedSize = selectedSize
         self.selectedColor = selectedColor
         self.quantity = quantity
     }
 }

 */
