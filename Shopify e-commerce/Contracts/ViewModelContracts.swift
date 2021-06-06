//
//  categoryViewModelContract.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/25/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift

protocol CategoryViewModelContract:ViewModelType{
    var mainCatDataObservable:Observable<[String]> {get}
    var subCatDataObservable:Observable<[String]> {get}
    var productDataObservable: Observable<[CategoryProduct]> {get}
    var data:[CategoryProduct]? {get}
    func fetchCatProducts(mainCat:String,subCat:String)
}

protocol SearchViewModelContract:ViewModelType{
    var dataObservable: Observable<[SearchProduct]>{get}
    
}
