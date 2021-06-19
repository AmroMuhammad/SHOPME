//
//  ProductDetailsTests.swift
//  Shopify e-commerceTests
//
//  Created by Ahmd Amr on 19/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import XCTest
@testable import Shopify_e_commerce

class ProductDetailsTests: XCTestCase {

    var realAPI: ProductDetailsAPIType!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        realAPI = ShopifyAPI.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        realAPI = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(true)
    }
    
    func testGetProductSuccess(){
        let expect = expectation(description: "product")
        realAPI.getProductDetails(productId: "6687365890246") { (product) in
            switch(product) {
            case .success(let res):
                expect.fulfill()
                XCTAssertEqual(res?.product.title, "ASICS TIGER | GEL-LYTE V '30 YEARS OF GEL' PACK")
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 5)
    }

    func testGetProductFail(){
        let expect = expectation(description: "teams")
        
        realAPI.getProductDetails(productId: "") { (res) in
            switch res {
            case .success(_):
                XCTFail()
            case .failure(let err):
                expect.fulfill()
                XCTAssertNotNil(err)
            }
        }
        waitForExpectations(timeout: 7)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
