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
    
    func saveUserDefaults(email:String,id:Int) -> Void {
        userDefaults.set(true, forKey: "isLogedIn")
        userDefaults.set(email, forKey: "email")
        userDefaults.set(id, forKey: "id")
    }
    func userStatus() -> (String,Bool,Int) {
        if(userDefaults.value(forKey: "email") != nil){
            let isLogedIn = userDefaults.bool(forKey: "isLogedIn")
            let email = userDefaults.value(forKey: "email") as! String
            let id = userDefaults.integer(forKey: "id");
        
        return(email,isLogedIn,id)
        }else{
            return("",false,0)
        }
    }
    func deleteUserDefaults() -> Void {
        userDefaults.set(false, forKey: "isLogedIn")
        userDefaults.set("", forKey: "email")
        userDefaults.set(0, forKey: "id")
    }
    
    private init(){
//        userDefaults.set(false, forKey: "isLogedIn")
//        userDefaults.set("", forKey: "email")
//        userDefaults.set(0, forKey: "id")
    }
}
