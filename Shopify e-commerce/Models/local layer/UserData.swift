//
//  UserData.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 30/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.

import Foundation
class UserData {
    public static let sharedInstance = UserData()
    private var userDefaults:UserDefaults
    
    private init(){
        userDefaults = UserDefaults.standard
    }
    
    func saveUserDefaults(customer:Customer) -> Void {
        userDefaults.set(true, forKey: Constants.isLoggedInUserDefaults)
        userDefaults.set(customer.email!, forKey: Constants.emailUserDefaults)
        userDefaults.set(customer.id!, forKey: Constants.idUserDefaults)
        userDefaults.set(customer.firstName!, forKey: Constants.firstNameUserDefaults)
        userDefaults.set(customer.lastName!, forKey: Constants.lastNameUserDefaults)
        userDefaults.set(customer.addresses![0]!.city!, forKey: Constants.cityUserDefaults)
        userDefaults.set(customer.addresses![0]!.country!, forKey: Constants.countryUserDefaults)
    }
    
    func isLoggedIn()->Bool{
        if(userDefaults.value(forKey: Constants.isLoggedInUserDefaults) != nil){
            return true
        }else{
            return false
        }
    }
    
    func getUserFromUserDefaults() -> Customer {
        let firstName = userDefaults.value(forKey: Constants.firstNameUserDefaults) as! String
        let lastName = userDefaults.value(forKey: Constants.lastNameUserDefaults) as! String
        let email = userDefaults.value(forKey: Constants.emailUserDefaults) as! String
        let id = userDefaults.value(forKey: Constants.idUserDefaults) as! Int
        let country = userDefaults.value(forKey: Constants.countryUserDefaults) as! String
        let city = userDefaults.value(forKey: Constants.cityUserDefaults) as! String
        return Customer(id: id, email: email, firstName: firstName, lastName: lastName, phone: nil, tags: nil, addresses: [Address(id: nil, customerID: nil, city: city, country: country)])
    }
    
    func deleteUserDefaults(){
        userDefaults.set(false, forKey: Constants.isLoggedInUserDefaults)
        userDefaults.set("", forKey: Constants.emailUserDefaults)
        userDefaults.set(0, forKey: Constants.idUserDefaults)
        userDefaults.set("", forKey: Constants.firstNameUserDefaults)
        userDefaults.set("", forKey: Constants.lastNameUserDefaults)
        userDefaults.set("", forKey: Constants.cityUserDefaults)
        userDefaults.set("", forKey: Constants.countryUserDefaults)
    }
    
}
