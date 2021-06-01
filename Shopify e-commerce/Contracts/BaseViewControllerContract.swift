//
//  BaseViewControllerContract.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/1/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
protocol BaseViewControllerContract {
    func showLoading()
    
    func hideLoading()
    
    func showErrorMessage(errorMessage: String)
}
