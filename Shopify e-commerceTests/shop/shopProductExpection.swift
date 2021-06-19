//
//  shopProductExpection.swift
//  Shopify e-commerceTests
//
//  Created by marwa on 6/18/21.
//  Copyright © 2021 ITI41. All rights reserved.
//
import Foundation
import XCTest
@testable import Shopify_e_commerce

class shopProductExpection: XCTestCase {
    var getDataobj : ShopifyAPI?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       getDataobj = ShopifyAPI.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        getDataobj = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testWomenProduct()  {
        
        let expecttionObj = expectation(description: "Wait for response")

        getDataobj?.getAllWomanProductData(completion: { (result) in
            switch result{
            case .success(let data):
                expecttionObj.fulfill()
                XCTAssertEqual(data?.products.count, 4)
                  
            case .failure(_):
                XCTFail()
            }
        })
        
        waitForExpectations(timeout: 5)
        
    }
    
    func testMenProduct()  {
        
        let expecttionObj = expectation(description: "Wait for response")

        getDataobj?.getAllMenProductData(completion: { (result) in
            switch result{
            case .success(let data):
                expecttionObj.fulfill()
                XCTAssertEqual(data?.products.count, 20)
                  
            case .failure(_):
                XCTFail()
            }
        })
        
        waitForExpectations(timeout: 5)
        
    }
    func testKidsProduct()  {
        
        let expecttionObj = expectation(description: "Wait for response")

        getDataobj?.getAllKidsProductData(completion: { (result) in
            switch result{
            case .success(let data):
                expecttionObj.fulfill()
                XCTAssertEqual(data?.products.count, 3)
                  
            case .failure(_):
                XCTFail()
            }
        })
        
        waitForExpectations(timeout: 5)
        
    }
    
    func testdiscountCode()  {
        
        let expecttionObj = expectation(description: "Wait for response")

        getDataobj?.getDiscountCodeData(completion: { (result) in
            switch result{
            case .success(let data):
                expecttionObj.fulfill()
                XCTAssertEqual(data?.discountCodes.count, 3)
                  
            case .failure(_):
                XCTFail()
            }
        })
        
        waitForExpectations(timeout: 5)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
