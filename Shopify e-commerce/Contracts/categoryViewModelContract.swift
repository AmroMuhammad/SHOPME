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
    var dataObservable:Observable<[String]> {get}
}
