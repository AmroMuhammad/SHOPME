//
//  UserData.swift
//  Shopify e-commerce
//
//  Created by Ayman Omara on 30/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.

import Foundation
class UserData {
   
    private var userDefaults = UserDefaults.standard
    private static var defaults:UserData = UserData()
    
    static func getInstance()->UserData{
        return defaults;
    }
    
    func saveUserDefaults(userID:String) -> Void {
        userDefaults.set(true, forKey: "isLogedIn")
        userDefaults.set(userID, forKey: "email")
    }
    func userStatus() -> (String,Bool) {
        var isLogedIn = userDefaults.bool(forKey: "isLogedIn")
        var email = userDefaults.value(forKey: "email") as! String
        return (email,isLogedIn)
        
    }
    func deleteUserDefaults() -> Void {
        userDefaults.set(false, forKey: "isLogedIn")
        userDefaults.set("", forKey: "email")
    }
    
    private init(){}
}
