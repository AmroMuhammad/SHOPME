//  RegisterViewController.swift
//  Shopify e-commerce
//  Created by Ayman Omara on 30/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
import UIKit

class RegisterViewController: UIViewController {
    
    let api = ShopifyAPI.shared
    var support = Support()
    
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var secondName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var confPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var meViewModel = MeViewModel();
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func submit(_ sender: Any) {
        meViewModel.validateRegisterdData(first: firstName.text!, last:secondName.text!, phone: phoneNumber.text!, password: password.text!, secPass: confPassword.text!, email: email.text!,country: country.text!,city: city.text!, context: self)
    }
    
}
