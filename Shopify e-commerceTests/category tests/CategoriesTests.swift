//
//  CategoriesTests.swift
//  Shopify e-commerceTests
//
//  Created by Amr Muhammad on 6/19/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import XCTest
@testable import Shopify_e_commerce

class CategoriesTests: XCTestCase {
    var categoriesRealAPI:CategoryAPIContract!
    var categoriesMockAPI:MockCategoryAPI!
    override func setUpWithError() throws {
        categoriesRealAPI = ShopifyAPI.shared
        categoriesMockAPI = MockCategoryAPI(shouldReturnError: false)
    }

    override func tearDownWithError() throws {
        categoriesRealAPI = nil
        categoriesMockAPI = nil
    }
    
    func testCategoryRealAPI() {
        let expect = expectation(description: "all categories")
        categoriesRealAPI.getCategoryProducts(catType: "Men") { (result) in
            switch result{
            case .failure(_):
                XCTFail()
            case .success(let categories):
                expect.fulfill()
                XCTAssertEqual(categories?.products.count, 20)
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    func testAllCategoriesMock(){
        categoriesMockAPI.getCategoryProducts(catType: "Men") { (result) in
            switch result{
                case .success(let cat):
                    XCTAssertEqual(cat?.products.count, 2)
                case .failure(_):
                    XCTFail()
            }
        }
    }
    
    
}
