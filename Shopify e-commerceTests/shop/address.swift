//
//  address.swift
//  Shopify e-commerceTests
//
//  Created by marwa on 6/19/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import XCTest
@testable import Shopify_e_commerce

class address: XCTestCase {
    var addressObj : addressViewModelType?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        addressObj = addressViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        addressObj = nil
    }
    
    func testAddressDetails(){
        let result =  addressObj?.getAddressDetails(address: "street1 , damietta , egypt ")
        
        XCTAssertEqual(result?.count, 3)
        
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
