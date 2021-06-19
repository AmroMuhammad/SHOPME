//
//  cart.swift
//  Shopify e-commerceTests
//
//  Created by marwa on 6/19/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import XCTest
@testable import Shopify_e_commerce

class cart: XCTestCase {
    var coreDataobj : LocalManagerHelper?
    var localObject : getLocalObj?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        localObject = getLocalObj()
        coreDataobj = LocalManagerHelper.localSharedInstance
    }

    override func tearDownWithError() throws {
        coreDataobj = nil
        localObject = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testgetCartData(){
        coreDataobj?.getAllCartProducts(userEmail: "marwash@gmail.com", completion: { (result) in
            if let result = result{
                XCTAssertEqual(result.count, 1)
            }else{
               XCTFail()
            }
        })
    }
    
    func testdeleteAllProductFromCart(){
        coreDataobj?.deleteAllProductFromCart(userEmail: "marwash@gmail.com", completion: { (result) in
            switch result{
            case true:
                XCTAssertEqual(result, true)
            case false:
                 XCTFail()
            }
        })
       }
    func testAddProductToCart(){
        
        coreDataobj?.addProductToCart(localProduct: localObject!.localDataObj, completion: { (result) in
         switch result{
         case true:
             XCTAssertEqual(result, true)
         case false:
              XCTFail()
         }
     })
    }
    
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
