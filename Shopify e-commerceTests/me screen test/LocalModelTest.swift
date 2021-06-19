//
//  LocalModelTest.swift
//  Shopify e-commerceTests
//
//  Created by Ayman Omara on 19/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import XCTest
@testable import Shopify_e_commerce

class LocalModelTest: XCTestCase {
    var meViewModel:MeViewModel!
    var userData:UserData!
    var customer:Customer!
    var address:Address!
    override func setUpWithError() throws {
        userData = UserData.sharedInstance

        meViewModel = MeViewModel()
        address = Address(id: 1, customerID: 1, city: "1", country: "1", address1: "1")
        address.id = 6487477125318
        address.customerID = 5283916480710
        address.city = "cairo"
        address.country = "Egypt"
        address.address1 = "EL Qnater"
        var ar:[Address] = [Address]()
        ar.append(address)
        customer = Customer(id: 0, email: "0", firstName: "0", lastName: "", phone: "", tags: "0", addresses: ar)
        customer.id = 5283916480710
        customer.firstName = "Ayman"
        customer.lastName = "Omara"
        customer.email = "aymanomara55@yahoo.com"
        customer.tags = "12"
        customer.phone = "01158093205"
        
        userData.saveUserDefaults(customer: customer)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        userData = nil
        meViewModel = nil
        customer = nil
        address = nil
        
    }


    func testIsLogedIn() throws{

        XCTAssertTrue(userData.isLoggedIn())
        userData.deleteUserDefaults()
        XCTAssertFalse(userData.isLoggedIn())
    }
    func testLogedInData() throws{
       XCTAssertNotNil(userData.getUserFromUserDefaults())
        var str = userData.getAddress()
        XCTAssertEqual(str,"EL Qnater, cairo, Egypt")
    }



    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
/*
 var id: Int?
 var email, firstName, lastName, phone: String?
 var tags: String?
 var addresses: [Address?]?

 enum CodingKeys: String, CodingKey {
     case id, email
     case firstName = "first_name"
     case lastName = "last_name"
     case addresses
     case phone, tags
 }
}

// MARK: - Address
struct Address: Codable {
 var id, customerID: Int?
 var city,country,address1: String?
 */
