//
//  CategoryAPIContract.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/1/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
protocol CategoryAPIContract {
    func getCategoryProducts(catType:String,completion: @escaping (Result<ProductModel?,NSError>) -> Void)
}

protocol AllProductsAPIContract {
    func getAllProducts(completion: @escaping (Result<AllProductsModel?, NSError>) -> Void)
}
