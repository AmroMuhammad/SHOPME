//
//  addAddressViewController.swift
//  Shopify e-commerce
//
//  Created by marwa on 6/15/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit

class addAddressViewController: UIViewController {
    var allAddress : String = ""
    var addressViewModelObj : addressViewModelType?
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var countryLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        addressViewModelObj = addressViewModel()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addBtn(_ sender: Any) {
        if(cityLabel.text?.isEmpty == true || countryLabel.text?.isEmpty == true || addressLabel.text?.isEmpty == true){
            Support.notifyUser(title: "missing", body: "all data is required", context: self)
        }
        else{
            let fullAddress = addressLabel.text! + "," + cityLabel.text! + "," + countryLabel.text!
            let resultAddress = allAddress + "#" + fullAddress
            
             //call function to store in core data
            addressViewModelObj?.storeAddressInUserDefault(addressAdded: resultAddress)
            
            //then call function to get from core data
           // addressViewModelObj?.getUserDefaultAddress()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
             self.dismiss(animated: true, completion: nil)
        }
     
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil )
    }
   
    
}
