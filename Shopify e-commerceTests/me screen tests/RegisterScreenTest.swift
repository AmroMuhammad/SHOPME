//
//  RegisterScreenTest.swift
//  Shopify e-commerceTests
//
//  Created by Amr Muhammad on 6/19/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import XCTest
@testable import Shopify_e_commerce
class RegisterScreenTest: XCTestCase {
    
    var registerViewModel:RegisterViewModel!
    var postCustomerRealAPI:RegisterAPIContract!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        registerViewModel = RegisterViewModel()
        postCustomerRealAPI = ShopifyAPI.shared
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        registerViewModel = nil
        postCustomerRealAPI = nil
    }

    func testRegisterValidation() throws {
        XCTAssertFalse(registerViewModel.nameRegexCheck(text: "0"))
        XCTAssertTrue(registerViewModel.nameRegexCheck(text: "SAMY"))
        XCTAssertFalse(registerViewModel.phoneNumRegexCheck(text: "a"))
        //less than 11 digit
        XCTAssertFalse(registerViewModel.phoneNumRegexCheck(text: "0115809320"))
        //11 digit
        XCTAssertTrue(registerViewModel.phoneNumRegexCheck(text: "01158093205"))
        // more than 11 digit
        XCTAssertFalse(registerViewModel.phoneNumRegexCheck(text: "011580932055"))
        
    }
//    func testDataFromUI() throws{
//        // data is empty
//        registerViewModel.validateRegisterdData(firstName: "", lastName: "", email: "", phoneNumber: "", password: "", confirmPassword: "", country: "", city: "", address: "")
//        XCTAssertEqual(registerViewModel.iserror, "empty feilds")
//        
//        // invalid firstname or last name
//        registerViewModel.validateRegisterdData(firstName: "0", lastName: "0", email: "ayman@yahoo.com", phoneNumber: "01158093205", password: "123456", confirmPassword: "123456", country: "a", city: "a", address: "a")
//        XCTAssertEqual(registerViewModel.iserror, "name regex")
//
//        // invalid phone number
//
//        registerViewModel.validateRegisterdData(firstName: "ayman", lastName: "ayman", email: "ayman@yahoo.com", phoneNumber: "0", password: "123456", confirmPassword: "123456", country: "a", city: "a", address: "a")
//        XCTAssertEqual(registerViewModel.iserror, "phone regex")
//
//        registerViewModel.validateRegisterdData(firstName: "ayman", lastName: "ayman", email: "ayman@yahoo.com", phoneNumber: "01158093205", password: "123456", confirmPassword: "12", country: "a", city: "a", address: "a")
//        XCTAssertEqual(registerViewModel.iserror, "password and confirmation password is not equal")
//    }
    
    func testPostHttpRequest() throws{
        //post fail because alraedy exist customer
        let expect = expectation(description: "post HTTP request is error or not")
        let newCustomer = RegisterCustomer(customer: Customer(id: nil, email: "aymanomara55@yahoo.com", firstName: "Ayman", lastName: "Omara", phone: "01158093207", tags: "password",addresses: [Address(id: nil, customerID: nil, city: "Cairo", country: "Egypt", address1: "address")]))
        
        
        postCustomerRealAPI.addCustomer(customerData: newCustomer) { (result) in
            switch(result){
            
            case .success(let cust):
                expect.fulfill()
                XCTAssertEqual(cust?.customer.firstName, "Ayman")
                
            case .failure(_):
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 6)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
