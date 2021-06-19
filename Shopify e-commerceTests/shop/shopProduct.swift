//
//  shopProduct.swift
//  Shopify e-commerceTests
//
//  Created by marwa on 6/18/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import XCTest
@testable import Shopify_e_commerce
class shopProduct: XCTestCase {
    var allProduct : AllProduct!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        allProduct = AllProduct(shouldReturnError: false)
    }

    override func tearDownWithError() throws {
        allProduct = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testGetAllProduct(){
        allProduct.fetchProductData { (product, error) in
            if let error = error{
                XCTFail()
            }else{
                XCTAssertEqual(product?.count, 2)
            }
        }

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

//import XCTest
//@testable import Sports_app
//
//class Sports_appTests: XCTestCase {
//    var allSportnetworkManger : AllSportNetworkManager!
//    override func setUpWithError() throws {
//
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        allSportnetworkManger = AllSportNetworkManager(shouldReturnError: false)
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        allSportnetworkManger = nil
//    }
//    func testGetAllSports(){
//
//        allSportnetworkManger.fetchSportsData { (sport, error) in
//            if let error = error{
//                XCTFail()
//            }else{
//                XCTAssertEqual(sport?.count, 2)
//            }
//        }
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}
