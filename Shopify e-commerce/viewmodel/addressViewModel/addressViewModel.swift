//
//  addressViewModel.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/15/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class addressViewModel : addressViewModelType{
   
    let defaults = UserDefaults.standard
   
    var userDefaultAddressDriver: Driver<[String]>
    var userDefaultAddressSubject = PublishSubject<[String]>()
    var addressDetailsDriver: Driver<[String]>
    var addressDetailsSubject = PublishSubject<[String]>()
    
      init() {
         userDefaultAddressDriver = userDefaultAddressSubject.asDriver(onErrorJustReturn: [] )
         addressDetailsDriver = addressDetailsSubject.asDriver(onErrorJustReturn: [] )
      }
    
    
    
    func getUserDefaultAddress(){
       let result = "6 october street , damietta , egypt # el shikh zayeed , ismailia , egypt" // get this value from user default
       splitUserDefaultAddress(userAddresses: result)
    }
    
    func splitUserDefaultAddress(userAddresses : String){
        let addressArray = userAddresses.components(separatedBy: "#")
        userDefaultAddressSubject.onNext(addressArray)
    }
    
    func getAddressDetails(address : String) -> [String]{
        let addressArray = address.components(separatedBy: ",")
        return addressArray
//        addressDetailsSubject.onNext(addressArray)
//          print("addressDetails from view model: \(addressArray)")
    }
    
}

